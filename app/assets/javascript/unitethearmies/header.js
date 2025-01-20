class Header {
  constructor() {
    this.header = $(".header");
    this.headerInner = $(".header-inner");
    this.logo = $(".logo");
    this.logoInner = $(".logo-inner");
    this.primaryNavigation = $(".primary-navigation");
    this.primaryNavigationUl = $(".primary-navigation ul");
    this.mobileNavigation = $(".mobile-navigation");
    this.mobileNavigationUl = $(".mobile-navigation ul");
    this.mobile = false;
  }

  showNavigation() {
    this.primaryNavigation.addClass("show-navigation");
    this.primaryNavigation.removeClass("text-end");
  }
  hideNavigation() {
    this.primaryNavigation.removeClass("show-navigation");
    this.primaryNavigation.addClass("text-end");
  }
  toggleNavigation() {
    this.mobile = !this.mobile;
    if (this.mobile) {
      this.showNavigation();
    } else {
      this.hideNavigation();
    }
  }
}

export default Header;
