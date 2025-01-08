## Load comments from database and save to file
#
namespace :fix_once do
  desc "Add anonymous true and confirmed true to all"
  task anonymous_and_confirmed_at: :environment do
    # Adds also slugs.
    comments = Comment.all
    comments.each do |comment|
      comment.anonymous = true
      comment.confirmed_at = Time.now
      puts "Added confirmed_at to #{comment.id}"
      comment.save
    end
  end

  desc "Fix comments one by one - set unconfirmed and fix language based on slug"
  task languages_and_confirmed_at: :environment do
    themes = ["administration","water","climate","protected-areas","plastic-waste"]
    themes.each do |theme|
      comments = Comment.where("slug like ?", "#{theme}--%")
      comments.each do |comment|
        comment.confirmed_at = nil
        puts "Removed confirmed_at (because empty), id:#{comment.id}"
        comment.save
      end
    end

    t = Time.new(2019)
    comments = Comment.where("created_at > ?", t)
    comments.each do |comment|
      comment.confirmed_at = nil
      puts "Removed confirmed_at (because after 2019), id:#{comment.id}"
      comment.save
    end

    spam = [
      "administration-testi-jokos-näme-tulee-mailiin-",
      "protected-areas-i-dont-onther-stand-",
      "plastic-waste-testing-",
      "plastic-waste-testing-again-"
    ]
    spam.each do |slug|
      comment = Comment.where("slug like ?", "#{slug}%").first
      comment.confirmed_at = nil
      puts "Removed confirmed_at (spam), id:#{comment.id}"
      comment.save
    end

    slugs = {
      finnish: [
        "administration-loistava-idea!!!-viimeinkin-sitä-yhtenäisyyttä-mitä-ihmiskuntaihmisyys-on-huutanut-itselleen-vuosituhansia!!!-",
        "water-vesi-elämän-lähde-meren-puhdistaminen-muovista-jpian-kalat-jo-kuolevat-ja-",
        "water-kannatan-ehdoitta-tätä-viisaiden-aloitetta-toivottavasti-vielä-ehdimme-nuhtelen-itseäni-ja-",
        "protected-areas-jos-rakastatte-elämää-niin-huolehtikaa-pallosta-jossa-elämme-aseilla-ja-sotilailla-",
        "water-olemme-suurimmaksi-osaksi-vettä-ja-sitä-meidän-tulee-säästää-jos-haluamme-",
        "protected-areas-kaiken-politiikan-pienten-ihmisten-suomen-ja-maailmankaikkeudessa-on-turvattava-elämän-monimuotoisuus-19",
        "administration-glopalisaatio-sehän-on-tämän-maailman-tuho-takaisin-kansallisvaltioihin-kyllä-donald-trump-",
        "protected-areas-suojelkaa-metsiä-niin-sademetsiä-kuin-myös-suomen-monipuolista-metsäluontoa-",
      ],
      english: [
        "administration-evironmental-subjects-should-be-related-to-cultural-and-educational-activities-our-",
        "administration-the-many-1000s-of-men-women-in-the-various-un-armed-",
        "water-save-nature-it-is-our-responsibility-for-future-",
        "protected-areas-there-must-be-a-sustainable-development-we-do-not-further-need-",
        "plastic-waste-perhaps-theres-a-solution-in-here-somewhere-httpswwweurekalertorgpubreleases2017-04uoc-cft042117php-",
        "water-now-its-our-turnif-a-small-drop-to-drop-can-fill-",
        "climate-we-must-insure-our-children-future-and-thier-right-of-life-",
        "plastic-waste-in-this-part-of-the-world-the-issue-of-fighting-plastic-",
        "climate-global-environment-recovery-economies-growths-proposals-low-carbon-co2-economies-revolution-draft-",
        "climate-dark-days-ahead-"
      ]
    }

    slugs.keys.each do |language|
      slugs[language].each do |slug|
        comment = Comment.where("slug like ?", "#{slug}%").first
        puts "Changed to #{language}, id:#{comment.id}"
        comment.language = language
        puts comment.valid?
        comment.save!
      end
    end
  end
end
