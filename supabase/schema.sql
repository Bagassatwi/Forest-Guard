-- Jalankan di Supabase > SQL Editor
create table if not exists public.detections (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  camera      text not null,          -- cam1 / cam2
  camera_name text,
  confidence  double precision,       -- probabilitas api (0-1)
  image_path  text not null,
  image_url   text not null
);
create index if not exists detections_created_idx on public.detections (created_at desc);

-- RLS aktif tanpa policy: hanya backend (service_role key) yang bisa baca/tulis tabel.
alter table public.detections enable row level security;

-- Bucket foto (public supaya gambar bisa tampil di dashboard)
insert into storage.buckets (id, name, public) values ('detections', 'detections', true)
on conflict (id) do nothing;
