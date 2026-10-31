-- PrintOps : à coller dans Supabase > SQL Editor, puis cliquer sur Run.
-- Rôles : p = Patron, r = Responsable de production, e = Employé, n = En attente (aucun accès).

create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  email text,
  name text,
  role text not null default 'n' check (role in ('p','r','e','n'))
);

create table if not exists public.records (
  id uuid primary key default gen_random_uuid(),
  coll text not null,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- À chaque nouveau compte : le tout premier devient Patron, les suivants sont « en attente ».
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', new.raw_user_meta_data->>'full_name', split_part(new.email,'@',1)),
    case when exists (select 1 from public.profiles) then 'n' else 'p' end
  );
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute function public.handle_new_user();

create or replace function public.my_role() returns text
language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid()
$$;

-- Accès par rubrique selon le rôle.
create or replace function public.can_coll(c text) returns boolean
language sql stable security definer set search_path = public as $$
  select case public.my_role()
    when 'p' then true
    when 'r' then c in ('commandes','taches','fiches','stock','machines','clients','docs','rapports')
    when 'e' then c in ('commandes','taches','fiches','stock','docs')
    else false
  end
$$;

alter table public.profiles enable row level security;
alter table public.records  enable row level security;

drop policy if exists profiles_read   on public.profiles;
drop policy if exists profiles_update on public.profiles;
create policy profiles_read   on public.profiles for select to authenticated using (id = auth.uid() or public.my_role() = 'p');
create policy profiles_update on public.profiles for update to authenticated using (public.my_role() = 'p') with check (public.my_role() = 'p');

drop policy if exists records_all on public.records;
create policy records_all on public.records for all to authenticated
  using (public.can_coll(coll)) with check (public.can_coll(coll));
