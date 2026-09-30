-- Jalankan sekali di Supabase → SQL Editor → New query → Run
create table kegiatan(
  id uuid primary key default gen_random_uuid(),
  bulan text not null,                 -- format 'YYYY-MM'
  judul text not null,
  deskripsi text default '',
  tags text[] default '{}',
  dokumentasi jsonb default '[]',      -- [{url,path,jenis,caption}]
  created_at timestamptz default now()
);
alter table kegiatan enable row level security;
create policy "publik boleh baca" on kegiatan for select using (true);
create policy "admin boleh tulis" on kegiatan for all to authenticated using (true) with check (true);

insert into storage.buckets(id,name,public) values('dokumentasi','dokumentasi',true) on conflict do nothing;
create policy "publik baca foto" on storage.objects for select using (bucket_id='dokumentasi');
create policy "admin upload foto" on storage.objects for insert to authenticated with check (bucket_id='dokumentasi');
create policy "admin hapus foto" on storage.objects for delete to authenticated using (bucket_id='dokumentasi');
