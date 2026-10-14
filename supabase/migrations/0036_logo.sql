-- =============================================================================
-- 0036_logo.sql
-- The logo, swappable by an administrator.
--
-- The co-op's logo appears in two populations that had nothing in common. One
-- is assets/koinonia-logo.jpg, worn by the portal, the administration site, the
-- teacher pages, the sign-up page and the printed waiver — a single file behind
-- ten references. The other is the dozen size variants WordPress generated,
-- which the mirrored public pages still point at.
--
-- Neither was reachable from the admin side. The photograph mechanism only sees
-- images inside mirrored pages, and only those over 20 KB; every logo variant is
-- between 1 and 5 KB, so none were ever offered, and the app's own logo is not
-- in a mirrored page at all.
--
-- Rather than build a second mechanism, the logo becomes one more row in
-- site_images, under a page name no real page can collide with. The publishing
-- job recognises it and writes the image over every logo file on disk, keeping
-- each one's name, so no HTML changes and every reference follows at once.
-- =============================================================================

select public.migration_guard('0036', '0035');

insert into public.site_images (page, img_key, original_src, alt, bytes)
select '__logo__', 'logo', 'assets/koinonia-logo.jpg', 'Koinonia', null
 where not exists (
   select 1 from public.site_images where page = '__logo__' and img_key = 'logo'
 );

comment on table public.site_images is
  'Replaceable images. One row per <img data-img> in a mirrored page, plus the '
  'row ("__logo__", "logo"), which is not a page: the publishing job writes that '
  'one over every logo file on disk instead of rewriting a tag.';

select public.record_migration('0036');
