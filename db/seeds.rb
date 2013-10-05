# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "Adventure Time",
             small_cover: "small_cover/adventure_time.jpeg",
             #large_cover: "",
             description: "Adventure Time (originally titled Adventure Time with Finn & Jake[2]) is an American animated television series created by Pendleton Ward for Cartoon Network. The series follows the adventures of Finn (voiced by Jeremy Shada), a human boy, and his best friend and adoptive brother Jake (voiced by John DiMaggio), a dog with magical powers to change shape and grow and shrink at will. Finn and Jake live in the post-apocalyptic Land of Ooo. Along the way, they interact with the other main characters of the show: Princess Bubblegum (voiced by Hynden Walch), The Ice King (voiced by Tom Kenny), and Marceline the Vampire Queen (voiced by Olivia Olson)." )

Video.create(title: "Family Guy",
             small_cover: "small_cover/family_guy.jpg",
             #large_cover: "",
             description: "Family Guy is an American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a dysfunctional family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture.")

Video.create(title: "Futurama",
             small_cover: "small_cover/futurama.jpg",
             #large_cover: "",
             description: "Futurama is an American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company. The series follows the adventures of a late-20th-century New York City pizza delivery boy, Philip J. Fry, who, after being unwittingly cryogenically frozen for one thousand years, finds employment at Planet Express, an interplanetary delivery company in the retro-futuristic 31st century. The series was envisioned by Groening in the late 1990s while working on The Simpsons, later bringing Cohen aboard to develop storylines and characters to pitch the show to Fox.")

Video.create(title: "Monk",
             small_cover: "small_cover/monk.jpg",
             large_cover: "large_cover/monk_large.jpg",
             description: "Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk. It originally ran from 2002 to 2009 and is primarily a mystery series, although it has dark and comic touches. The series was produced by Mandeville Films and Touchstone Television in association with Universal Television.")

Video.create(title: "Oggy and the Cockroaches",
             small_cover: "small_cover/oggy.jpg",
             #large_cover: "",
             description: "The show centers on Oggy, a content, lazy, fat blue cat, who would prefer to spend his days watching television and eating - if not for the three roaches in the household: Joey, Dee Dee and Marky (named after members of the punk group Ramones). The trio seems to enjoy making Oggy's life miserable, which involves mischief ranging from (in most cases) plundering his fridge to such awkward things like hijacking the train Oggy just boarded. Oggy usually finds creatures accompanying him to the end of the episode, such as crabs, clams, a horse, a very technologically advanced child, a puppy, and an octopus. However, it's not always Oggy who wins.")

Video.create(title: "Regular Show",
             small_cover: "small_cover/regular_show.jpg",
             #large_cover: "",
             description: "Regular Show is an American animated television series created by J. G. Quintel for Cartoon Network that premiered on September 6, 2010. The series revolves around the lives of two friends, a Blue Jay named Mordecai (Quintel) and a raccoon named Rigby (William Salyers)—both employed as groundskeepers at a local park. Their regular attempts to slack off usually lead to surreal, extreme and often supernatural misadventures. During these misadventures, they interact with the show's other main characters: Benson (Sam Marin), Pops (Marin), Muscle Man (Marin), Hi-Five Ghost (Quintel), Skips (Mark Hamill) and Margaret (Janie Haddad-Tompkins).")

Video.create(title: "South Park",
             small_cover: "small_cover/south_park.jpg",
             #large_cover: "",
             description: "South Park is an American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network. Intended for mature audiences, the show has become famous for its crude language and dark, surreal humor that satirizes a wide range of topics. The ongoing narrative revolves around four boys—Stan Marsh, Kyle Broflovski, Eric Cartman and Kenny McCormick—and their bizarre adventures in and around the titular Colorado town.")



Category.create(name: "TV Commedies")
Category.create(name: "TV Dramas")
Category.create(name: "Reality TV")

Video.all.each do |video|
  Category.all.each do |category|
    video.categories << category
  end
end
