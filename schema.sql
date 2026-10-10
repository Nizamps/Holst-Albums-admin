-- Run once in Supabase > SQL Editor
create table public.orders(
 id text primary key, created_at timestamptz default now(),
 theme text, size text, title text, year text, note text,
 name text, phone text, email text, addr text, city text, pin text,
 pay text, total int, status text default 'New', photo_paths jsonb default '[]');
alter table public.orders enable row level security;
create policy "customers place orders" on public.orders for insert to anon with check (status='New');
create policy "admin reads orders" on public.orders for select to authenticated using (true);
create policy "admin updates orders" on public.orders for update to authenticated using (true) with check (true);
create policy "admin deletes orders" on public.orders for delete to authenticated using (true);

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('album-photos','album-photos',false,10485760,array['image/jpeg']) on conflict do nothing;
create policy "customers upload photos" on storage.objects for insert to anon with check (bucket_id='album-photos');
create policy "admin reads photos" on storage.objects for select to authenticated using (bucket_id='album-photos');
create policy "admin deletes photos" on storage.objects for delete to authenticated using (bucket_id='album-photos');

alter publication supabase_realtime add table public.orders; -- live "new order" alerts
