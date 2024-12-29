class Comment {
  constructor() {
    // Language identifier and name in english.
    this.data = {
      language_identifier: null,
      language_name: null,
      topic: null,
      comment: null,
      email: null,
    };
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
    $(".language_active").each(function () {
      $(this).removeClass("language_active");
    });
    $(el).addClass("language_active");
    this.setConclusion();
  }

  set topic(topic) {
    this.data.topic = topic;
  }
  get topic() {
    return this.data.topic;
  }

  setTopic(el, topic) {
    this.data.topic = topic;
    $(".comment_active").each(function () {
      $(this).removeClass("comment_active");
    });
    $(el).addClass("comment_active");
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
    if (this.topic && this.language_name) {
      result = `Your comment is about ${this.topic}, and it is written in ${this.language_name}.`;
    } else if (this.topic) {
      result = `Your comment is about ${this.topic}. You have not selected language.`;
    } else if (this.language_name) {
      result = `Your comment is written in ${this.language_name}, but you have not selected topic.`;
    } else {
      result = `You have not selected topic nor language.`;
    }
    return result;
  }

  setConclusion() {
    $(".comment_conclusion").html(this.conclusion());
  }

  showDescription() {
    let details = topic_details[this.topic];
    if (!details) {
      return;
    }
    $(".comment_description").html(details.description).show();
  }
}
