class Comment {
  constructor() {
    // Language identifier and name in english.
    this.data = {
      language: null,
      language_name: null,
      theme: null,
      comment: null,
      email: null,
    };
  }

  send() {
    $("#comment_form").find('input[name="language"]').val(this.data.language);
    $("#comment_form").find('input[name="theme"]').val(this.data.theme);
    $("#comment_form").submit();
  }

  set language_identifier(language) {
    this.data.language_identifier = language;
  }
  get language_identifier() {
    return this.data.language;
  }

  set language_name(name) {
    this.data.language_name = name;
  }
  get language_name() {
    return this.data.language_name;
  }
  setLanguage(el, name, identifier) {
    this.data.language_identifier = identifier;
    this.data.language_name = name;
    $("#comment_language").val(identifier);
    console.log($("#comment_language"));
    $(".language_active").each(function () {
      $(this).removeClass("language_active");
    });
    $(el).addClass("language_active");
    this.setConclusion();
  }

  set theme(theme) {
    this.data.theme = theme;
  }
  get theme() {
    return this.data.theme;
  }

  setTheme(el, theme) {
    this.data.theme = theme;
    $("#comment_theme").val(theme);
    $(".theme_active").each(function () {
      $(this).removeClass("theme_active");
    });
    $(el).addClass("theme_active");
    this.setConclusion();
    this.showDescription();
  }

  set comment(comment) {
    this.data.comment = comment;
  }
  get comment() {
    return this.data.comment;
  }

  set email(email) {
    this.data.email = email;
  }
  get email() {
    return this.data.email;
  }

  conclusion() {
    let result = "";
    if (this.theme && this.language_name) {
      result = `Your comment is about ${this.theme}, and it is written in ${this.language_name}.`;
    } else if (this.theme) {
      result = `Your comment is about ${this.theme}. You have not selected language.`;
    } else if (this.language_name) {
      result = `Your comment is written in ${this.language_name}, but you have not selected theme.`;
    } else {
      result = `You have not selected theme nor language.`;
    }
    return result;
  }

  setConclusion() {
    $(".comment_conclusion").html(this.conclusion());
  }

  showDescription() {
    let details = theme_details[this.theme];
    if (!details) {
      return;
    }
    $(".comment_description").html(details.description).show();
  }
}
