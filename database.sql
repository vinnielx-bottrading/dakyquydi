create extension if not exists pgcrypto;

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.stories (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  country text not null,
  region text not null,
  type text not null default '',
  excerpt text not null,
  body text not null,
  origin text not null default '',
  variants text not null default '',
  cover_url text,
  status text not null default 'draft' check (status in ('draft','published')),
  featured boolean not null default false,
  published_at timestamptz,
  seo_title text not null default '',
  seo_description text not null default '',
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_story_audit_fields()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  new.updated_at = now();
  if tg_op = 'INSERT' then new.created_by = auth.uid(); end if;
  return new;
end; $$;

drop trigger if exists stories_audit on public.stories;
create trigger stories_audit before insert or update on public.stories
for each row execute function public.set_story_audit_fields();

alter table public.admins enable row level security;
alter table public.stories enable row level security;

drop policy if exists "Public reads published stories" on public.stories;
create policy "Public reads published stories" on public.stories for select
using (status = 'published' and published_at is not null and published_at <= now());

drop policy if exists "Admins manage all stories" on public.stories;
create policy "Admins manage all stories" on public.stories for all to authenticated
using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));

drop policy if exists "Admins see own membership" on public.admins;
create policy "Admins see own membership" on public.admins for select to authenticated
using (user_id = auth.uid());

insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('story-covers','story-covers',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=excluded.public,file_size_limit=excluded.file_size_limit,allowed_mime_types=excluded.allowed_mime_types;

drop policy if exists "Public reads story covers" on storage.objects;
create policy "Public reads story covers" on storage.objects for select using (bucket_id='story-covers');
drop policy if exists "Admins upload story covers" on storage.objects;
create policy "Admins upload story covers" on storage.objects for insert to authenticated
with check (bucket_id='story-covers' and exists(select 1 from public.admins a where a.user_id=auth.uid()));
drop policy if exists "Admins update story covers" on storage.objects;
create policy "Admins update story covers" on storage.objects for update to authenticated
using (bucket_id='story-covers' and exists(select 1 from public.admins a where a.user_id=auth.uid()))
with check (bucket_id='story-covers' and exists(select 1 from public.admins a where a.user_id=auth.uid()));
drop policy if exists "Admins delete story covers" on storage.objects;
create policy "Admins delete story covers" on storage.objects for delete to authenticated
using (bucket_id='story-covers' and exists(select 1 from public.admins a where a.user_id=auth.uid()));

-- Sau khi tạo tài khoản quản trị trong Authentication, chạy riêng lệnh sau:
-- insert into public.admins(user_id) values ('UUID_CUA_TAI_KHOAN');
