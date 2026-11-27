-- Activation de l'extension pgcrypto
create
extension if not exists pgcrypto;

-- Création de la fonction permettant de générer 10 caractères alphanumériques aléatoires
create
or replace function public.random_alphanumeric_10()
returns text
language plpgsql
volatile
set search_path = ''
as $$
declare
chars text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    chars_len
int := length(chars);
    result
text := '';
    rand_bytes
bytea;
    i
int;
    idx
int;
begin
    rand_bytes
:= gen_random_bytes(10);

for i in 0..9 loop
        idx := (get_byte(rand_bytes, i) % chars_len) + 1;
        result
:= result || substr(chars, idx, 1);
end loop;

return result;
end;
$$;

-- Création des tables
create table if not exists public.profiles
(
    id
    uuid
    primary
    key
    references
    auth
    .
    users
(
    id
) on delete cascade,
    full_name text,
    email text,
    created_at timestamptz default now
(
)
    );

create table if not exists public.turbines
(
    id
    serial
    primary
    key,
    profile_id
    uuid
    references
    public
    .
    profiles
(
    id
),
    serial_number text unique,
    custom_name text,
    sec_hash_code uuid,
    latitude double precision,
    longitude double precision,
    activated boolean default false,
    last_seen_at timestamptz default now
(
),
    created_at timestamptz default now
(
)
    );

create
or replace view public.turbines_with_status as
select t.*,
       case
           when extract(epoch from (now() - t.last_seen_at)) >= 30 then 'INACTIVE'
           else 'ACTIVE'
           end as status
from public.turbines t;



create table if not exists public.pairing_codes
(
    turbine_id
    integer
    references
    public
    .
    turbines
(
    id
) on delete cascade,
    code_hash text default public.random_alphanumeric_10
(
),
    created_at timestamptz default now
(
),
    expires_at timestamptz default
(
    now
(
) + interval '15 minutes'),
    validated_at timestamptz,
    primary key
(
    turbine_id,
    created_at
)
    );

create
or replace view public.pairing_codes_with_status as
select pc.*,
       case
           when pc.validated_at is null and pc.expires_at > now() then 'VALID'
           else 'INVALID'
           end as status
from public.pairing_codes pc;

create table if not exists public.telemetries
(
    turbine_id
    integer
    references
    public
    .
    turbines
(
    id
) on delete cascade,
    power_w double precision,
    rotation_rpm double precision,
    orientation_deg double precision,
    recorded_at timestamptz default now
(
),
    received_at timestamptz default now
(
),
    primary key
(
    turbine_id,
    recorded_at
)
    );

create table if not exists public.telemetries_hourly
(
    turbine_id
    integer
    references
    public
    .
    turbines
(
    id
) on delete cascade,
    avg_power_w double precision,
    max_power_w double precision,
    energy_wh double precision,
    avg_rpm double precision,
    bucket_start timestamptz default now
(
),
    primary key
(
    turbine_id,
    bucket_start
)
    );

create or replace view total_power_view as
select a.profile_id, sum(b.power_w) from public.turbines a join public.telemetries b on a.id = b.turbine_id group by(a.profile_id);

-- Privilèges sur les tables
grant select, insert, update, delete on public.profiles to authenticated, service_role;
grant select, insert, update, delete on public.turbines to authenticated, service_role;
grant select, insert, update, delete on public.pairing_codes to authenticated, service_role;
grant insert on public.telemetries to anon;
grant select, insert, update, delete on public.telemetries to authenticated, service_role;
grant select, insert, update, delete on public.telemetries_hourly to authenticated, service_role;

-- Activation du Row Level Security (RLS)
alter table public.profiles enable row level security;
alter table public.turbines enable row level security;
alter table public.pairing_codes enable row level security;
alter table public.telemetries enable row level security;
alter table public.telemetries_hourly enable row level security;

-- Création automatique du profil lors de l'inscription dans auth.users
create
or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
insert into public.profiles (id, email, full_name)
values (new.id, new.email, new.raw_user_meta_data ->> 'full_name');
return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
    after insert
    on auth.users
    for each row execute function public.handle_new_user();

-- Politiques RLS : profiles
create
policy "Users can view their own profile"
on public.profiles for
select
    to authenticated
    using ((select auth.uid()) = id);

create
policy "Users can update their own profile"
on public.profiles for
update
    to authenticated
    using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

-- Politiques RLS : turbines
create
policy "Users can select their own turbines"
on public.turbines for
select
    to authenticated
    using ((select auth.uid()) = profile_id and activated = true);

create
policy "Users can insert their own turbines"
on public.turbines for insert
to authenticated
with check ((select auth.uid()) = profile_id);

create
policy "Users can update their own turbines"
on public.turbines for
update
    to authenticated
    using ((select auth.uid()) = profile_id)
with check ((select auth.uid()) = profile_id);

create
policy "Users can delete their own turbines"
on public.turbines for delete
to authenticated
using ((select auth.uid()) = profile_id);

-- Politiques RLS : telemetries
create
policy "Users can select their own turbines telemetry"
on public.telemetries for
select
    to authenticated
    using (
    exists (
    select 1
    from public.turbines t
    where t.id = public.telemetries.turbine_id
    and t.activated = true
    and t.profile_id = (select auth.uid())
    )
    );

-- Politiques RLS : telemetries_hourly
create
policy "Users can select their own turbines telemetry hourly aggregates"
on public.telemetries_hourly for
select
    to authenticated
    using (
    exists (
    select 1
    from public.turbines t
    where t.id = public.telemetries_hourly.turbine_id
    and t.activated = true
    and t.profile_id = (select auth.uid())
    )
    );

create
policy "Users can insert their own turbines telemetry hourly aggregates"
on public.telemetries_hourly for insert
to authenticated
with check (
    exists (
        select 1
        from public.turbines t
        where t.id = public.telemetries_hourly.turbine_id
          and t.activated = true
          and t.profile_id = (select auth.uid())
    )
);

create
policy "Users can update their own turbines telemetry hourly aggregates"
on public.telemetries_hourly for
update
    to authenticated
    using (
    exists (
    select 1
    from public.turbines t
    where t.id = public.telemetries_hourly.turbine_id
    and t.activated = true
    and t.profile_id = (select auth.uid())
    )
    )
with check (
    exists (
    select 1
    from public.turbines t
    where t.id = public.telemetries_hourly.turbine_id
    and t.activated = true
    and t.profile_id = (select auth.uid())
    )
    );

create
policy "Users can delete their own turbines telemetry hourly aggregates"
on public.telemetries_hourly for delete
to authenticated
using (
    exists (
        select 1
        from public.turbines t
        where t.id = public.telemetries_hourly.turbine_id
          and t.activated = true
          and t.profile_id = (select auth.uid())
    )
);

-- Politiques RLS : pairing_codes
create
policy "Users can select their own turbines pairing codes"
on public.pairing_codes for
select
    to authenticated
    using (
    exists (
    select 1
    from public.turbines t
    where t.id = public.pairing_codes.turbine_id
    and t.profile_id = (select auth.uid())
    )
    );

create
policy "Users can insert their own turbines pairing codes"
on public.pairing_codes for insert
to authenticated
with check (
    exists (
        select 1
        from public.turbines t
        where t.id = public.pairing_codes.turbine_id
          and t.profile_id = (select auth.uid())
    )
);

create
policy "Users can update their own turbines pairing codes"
on public.pairing_codes for
update
    to authenticated
    using (
    exists (
    select 1
    from public.turbines t
    where t.id = public.pairing_codes.turbine_id
    and t.profile_id = (select auth.uid())
    )
    )
with check (
    exists (
    select 1
    from public.turbines t
    where t.id = public.pairing_codes.turbine_id
    and t.profile_id = (select auth.uid())
    )
    );

create
policy "Users can delete their own turbines pairing codes"
on public.pairing_codes for delete
to authenticated
using (
    exists (
        select 1
        from public.turbines t
        where t.id = public.pairing_codes.turbine_id
          and t.profile_id = (select auth.uid())
    )
);

-- Insertion d'une télémétrie par la turbine
create
or replace function public.turbine_insert_telemetry(
    p_serial_number text,
    p_sec_hash_code text,
    p_power_w double precision,
    p_rotation_rpm double precision,
    p_orientation_deg double precision
)
returns void
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
v_turbine_id integer;
    v_sec_hash
uuid;
begin
begin
        v_sec_hash
:= p_sec_hash_code::uuid;
exception when invalid_text_representation then
        return;
end;

select t.id
into v_turbine_id
from public.turbines t
where t.serial_number = p_serial_number
  and t.sec_hash_code = v_sec_hash
  and t.activated = true;

if
v_turbine_id is null then
        return;
end if;

update public.turbines
set last_seen_at = now()
where id = v_turbine_id;

insert into public.telemetries (turbine_id, power_w, rotation_rpm, orientation_deg)
values (v_turbine_id, p_power_w, p_rotation_rpm, p_orientation_deg);
end;
$$;

-- Activation d'une turbine via un code d'appairage valide
create
or replace function public.turbine_activate(
    p_serial_number text,
    p_hash_code text
)
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
v_turbine_id integer;
    v_sec_hash_code
uuid;
begin
select t.id
into v_turbine_id
from public.pairing_codes pc
         join public.turbines t on t.id = pc.turbine_id
where t.serial_number = p_serial_number
  and pc.code_hash = p_hash_code
  and pc.validated_at is null
  and pc.expires_at > now()
order by pc.created_at desc limit 1;

if
v_turbine_id is null then
        return null;
end if;

    v_sec_hash_code
:= gen_random_uuid();

update public.pairing_codes
set validated_at = now()
where turbine_id = v_turbine_id
  and code_hash = p_hash_code
  and validated_at is null;

update public.turbines
set activated     = true,
    sec_hash_code = v_sec_hash_code
where id = v_turbine_id;

return v_sec_hash_code::text;
end;
$$;