/// ConnectMe named route constants and route enum.
///
/// Centralizing route paths prevents magic string duplication
/// and enables IDE-assisted navigation refactoring.
enum AppRouter {
  splash('/', 'splash'),
  login('/login', 'login'),
  signUp('/sign-up', 'sign-up'),
  forgotPassword('/forgot-password', 'forgot-password'),
  home('/home', 'home'),
  profile('/profile', 'profile'),
  editProfile('/edit-profile', 'edit-profile'),
  search('/search', 'search'),
  activity('/activity', 'activity'),
  createPost('/create-post', 'create-post'),
  postDetail('/post-detail', 'post-detail'),
  map('/map', 'map'),
  memberProfile('/member-profile', 'member-profile');

  final String path;
  final String name;

  const AppRouter(this.path, this.name);
}
