namespace :fix do
  desc "print folder"
  task print: :environment do
    system("ls bin")
  end

  desc "fix spam"
  task spam: :environment do
    emails = [ "iuabvt@evnfas.com",
    "zgecgh@qyeyls.com",
    "wcsjrm@usttwl.com",
    "jblrkf@yatfna.com",
    "carenday770@gmail.com",
    "johnmerritt495@gmail.com",
    "johnmarshall4804@gmail.com",
    "robertwilkinson8711@gmail.com",
    "smfann@mqzuoi.com",
    "08b90f35ab2d697f63eda954527da8b1@ssemarketing.net",
    "prospercrawford915@gmail.com",
    "smiththomasine6@gmail.com",
    "xcsbpz@zzislw.com",
    "danielsimpson5313@gmail.com",
    "zawqnp@qhyzue.com",
    "arveyrosemary@gmail.com",
    "llisoncorey@gmail.com",
    "btqfch@jpdbud.com",
    "johngreen9702@gmail.com",
    "goldenmervyn4@gmail.com",
    "roberthamilton9572@gmail.com",
    "wsscma@uodgtl.com",
    "dobsonsmithio34ga2@yahoo.com",
    "ohnothorkehk@gmail.com",
    "plegingsvh@gmail.com",
    "keeciangsj@gmail.com",
    "warenihoigaise@gmail.com",
    "410c4a44cc1b70307e70aa9202cd681dprx@ssemarketing.net",
    "69909eefbf9ca8387089e0dcac654c19prx@ssemarketing.net",
    "sibciverge2@gmail.com",
    "nukurokuhiji@gmail.com",
    "zgkvki@ixsjyy.com",
    "cangocorddist2000@gmail.com",
    "sponincatuc@gmail.com",
    "jbsyxf@jtakde.com",
    "baileyv034@gmail.com",
    "prestonhunter522@gmail.com",
    "fojkjg@kunwty.com",
    "christopherpowers1092@gmail.com",
    "waelchipshnw60@gmail.com",
    "cassandraicg32@gmail.com",
    "mirz27dq3xf@hotmail.com",
    "bmark8176@gmail.com",
    "charlestaylor4959@gmail.com",
    "darrickzhvr21@gmail.com",
    "davidmartin8834@gmail.com",
    "duudbd@daixxt.com",
    "tuckermatthew489@gmail.com",
    "lindicandj@gmail.com",
    "nucanceszx@gmail.com",
    "mfdapb@oktlvc.com", "branstramosbranstr@gmail.com",
    "taalvolcanomccory@gmail.com",
    "fzekzs@xxvinn.com",
    "phositacksjh@gmail.com",
    "thinjectzp@gmail.com",
    "philomenaprobabilistic@gmail.com",
    "davidmorgan6992@gmail.com",
    "markbarton9941@gmail.com",
    "fitzgeraldrobert05@gmail.com",
    "daphnes406@gmail.com",
    "estesbooker@gmail.com",
    "bo962806@gmail.com",
    "sae271363@gmail.com",
    "walterquentin251@gmail.com",
    "nwodda@cscmrd.com",
    "jessicamcdowell2915@gmail.com",
    "jd338697@gmail.com",
    "albertglenn6493@gmail.com",
    "rwade449@gmail.com",
    "fmhamr@lldijy.com",
    "elenihamtfam08j7w4@gmail.com",
    "fannybobby0w4u4ps@gmail.com",
    "gfox4842@gmail.com",
    "mirabellanoveliahb5588f9r@gmail.com",
    "vladamirdario318pn63@gmail.com",
    "laciejvhaf39@gmail.com",
    "laetitiazpbmi72@gmail.com",
    "mcgeeannice94@gmail.com",
    "baldwindonald035@gmail.com",
    "samuelthomas4932@gmail.com",
    "KatherinexTurnerMdb@gmail.com",
    "MariomMatthewsA3Wy@gmail.com",
    "bernardjimenez805620@gmail.com",
    "vt2131205@gmail.com",
    "clarebaker8098@gmail.com",
    "barryharris685809@gmail.com",
    "tristanni41953@gmail.com",
    "brandahall18@gmail.com",
    "lialexander566@gmail.com",
    "abbottmcdowell431178@gmail.com",
    "perryorozco302352@gmail.com",
    "heathcaleb52@gmail.com",
    "ashleermunits@gmail.com",
    "sherikah486@gmail.com",
    "melisendalowis@gmail.com",
    "madelmundmb@gmail.com",
    "jamarcushodgehgf@gmail.com",
    "kennediramirez453@gmail.com",
    "boyduseaglef901@gmail.com",
    "immanuelleonard79@gmail.com",
    "scottvsvj@gmail.com",
    "rogersgd334@gmail.com",
    "syfhdjfucyg@gmail.com",
    "sedasertf710@gmail.com",
    "bengukerim30@gmail.com",
    "Lindarksharonuy6436@gmail.com",
    "pakefgirnubedazhe@gmail.com",
    "Akejtepatriciauq5340@gmail.com",
    "toftgregmoore8126@gmail.com",
    "hannersi9revelling@gmail.com",
    "brendontitenbockc@gmail.com",
    "anjela812vy4xe5@outlook.com",
    "mayme70f09145i46u@outlook.com",
    "sjamesedward67a958as@outlook.com",
    "ufred53e3ge64u@outlook.com",
    "chuee51ve942e86e@outlook.com",
    "bsimonab5287y7a7u41@outlook.com",
    "hbernie2t4hb70h8@outlook.com",
    "qtacia82e9n5li2q2j@outlook.com",
    "romeu7a38ce5n46@outlook.com",
    "urosalee48y0uo2@outlook.com",
    "chindae7y542xzj4wo7@outlook.com",
    "tbridgette7217aday26t@outlook.com",
    "corissaa65ju140s7@outlook.com",
    "chelsi7udu563w1@outlook.com",
    "catelync0u94bze@outlook.com",
    "lecia178gy87ewj1517q@outlook.com",
    "nlaisa4ye4snl1o2@outlook.com",
    "phucy52mu5u297n@outlook.com" ]

    Vote.all.each do |vote|
      if emails.include?(vote.email)
        vote.email_confirmation = vote.email
        vote.spam = true
        vote.save
        puts vote.email
      end
    end
  end
end
