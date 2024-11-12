class OoELogic
  
  def initialize(c, o)
    @checker = c
    @options = o
  end
  
  def hasItem(item)
    @checker.current_items.include?(item)
  end
  
  def villagerCount(n)
    return true #todo
  end
  
  def hasFire
    hasItem("Ignis") || hasItem("Vol Ignis") || hasItem("Nitesco")
  end
  
  #Light is considered progression to beat castle bosses after Blackmore, unless you pick the hardest difficulty.
  def hasLight
    ( @options[:rv_difficulty] == "Do Your Worst") \
      || hasItem("Luminatio") || hasItem("Vol Luminatio") || hasItem("Nitesco")
  end
  
  def hasFlight
    if @options[:rv_difficulty] == "Vanilla"
      hasItem("Volaticus")
    else
      hasItem("Redire") && hasItem("Magnes")
    end
  end
  
  def highJump
    hasItem("Ordinary Rock") || hasFlight()
  end
  
  def speedBoots
    if @options[:rv_difficulty] == "Vanilla"
      return false
    else
      hasItem("Moonwalkers") || hasItem("Winged Boots") || hasItem("Mercury Boots")
    end
  end
  
  def catTackle
    if @options[:rv_difficulty] == "Vanilla"
      return false
    else
      hasItem("Cat Tackle") || hasItem("Arma Felix")
    end
  end
  
  def crossSpikes
    ( @options[:rv_difficulty] == "Do Your Worst" ) \
      || hasItem("Magnes") || hasItem("Arma Machina")
  end
  
  def smallDistance()
    catTackle() || speedBoots() || midDistance()
  end
  
  def midDistance()
    ( catTackle() && ( hasItem("Moonwalkers") || hasItem("Winged Boots") ) ) \
      || farDistance()
  end
  
  def farDistance()
     hasFlight() \
       || ( @options[:rv_difficulty] != "Vanilla" ) && hasItem("Rapidus Fio")
  end
  
  #Todo: add logic for surviving in the castle
  alias castleEntry highJump
  
  def castleEntranceEast
    castleEntry() && hasItem("Paries")
  end
  
  def beatBlackmore
    castleEntranceEast() && ( hasFire() || hasLight() )
  end
  
  def mechTower
    beatBlackmore() && ( hasItem("Magnes") || hasFlight() )
  end
  
  #Todo: include logic for the battle itself
  alias beatDeath mechTower
  
  def fulgurPuzzle
    @options[:rv_puzzle_progression] && mechTower() \
        && ( hasItem("Fulgur") || hasItem("Vol Vulgur") )
  end
  
  #If you're stubborn you can divekick off the imp to get into Arms Depot...
  #You can't jump out, but there's a teleporter so you can't be locked in.
  def armsDepot
    mechTower() \
      || ( @options[:rv_difficulty] == "Do Your Worst") && beatBlackmore()
  end
  
  #Todo: include logic for the battle itself
  alias beatEligor armsDepot
  
  def finalApproach
    hasItem("Dextro Custos") && hasItem("Sinestro Custos") && hasItem("Arma Custos") \
      && castleEntranceEast()
  end
  
  def volaticusAttic
    finalApproach() && hasFlight()
  end
  
  def beatDracula
    hasItem("Dominus Hatred") && hasItem("Dominus Anger") && hasItem("Dominus Agony") \
      && volaticusAttic()
  end
  
  def trainingHall
    case @options[:rv_difficulty]
    when "Vanilla"
      false
    when "Creative"
      hasItem("Magnes") && hasItem("Ordinary Rock")
    when "Do Your Worst"
      hasItem("Magnes") && ( hasItem("Ordinary Rock") || hasItem("Redire") )
    end
  end
  
  #Masochist logic could allow traveling underwater with Redire's backswing in map rando.
  def underwater
    hasItem("Serpent Scale")
  end
  
  def kalidusDepths
    underwater() && beatCrab()
  end
  
  #Todo: add crushing/fire damage reqs for easy-level logic
  def beatGiantSkeleton
    return true
  end
  
  def mineraTower
    beatGiantSkeleton() && highJump()
  end
  
  def mineraEnd
    beatGiantSkeleton() \
      && ( hasItem("Magnes") || hasFlight() \
        || ( @options[:rv_difficulty] != "Vanilla" ) && hasItem("Ordinary Rock") 
      )
  end
  
  def lighthouse
    crossSpikes() || hasItem("Rapidus Fio") || ( highJump() && smallDistance() )
  end
  
  def beatCrab
    lighthouse() && ( hasItem("Magnes") || highJump() )
  end
  
  def tymeoMidway
    crossSpikes() || hasFlight()
  end
  
  def tymeoEast
    tymeoMidway() && ( midDistance() || highJump() )
  end
  
  def tymeoParies
    tymeoEast() && hasItem("Paries")
  end
  
  def pneumaPuzzle
    tymeoEast() && hasItem("Magnes")
  end
  
  def tristisWaterfall
    highJump() && hasItem("Magnes")
  end
  
  alias giantsDwelling highJump
  
  def mysteryManor
    highJump() || smallDistance()
  end
  
  def beatAlbus
    kalidusDepths() && tristisWaterfall()
  end
  
  def mistyJumpWest
     farDistance() || ( highJump() && smallDistance() )
  end
  
  #Todo: In easy logic, add reqs for slash/fire/stone damage to kill lizardmen
  def mistyParies
    hasItem("Paries")
  end
  
  #Todo: easy logic survival reqs?
  def mistyRoad
    return true
  end
  
  def mistyJumpEast
    mistyJumpWest() || hasItem("Magnes")
  end
  
  #Todo: add fight reqs
  def beatFish
    return true
  end
  
  alias oblivionJump mistyJumpWest
  
  #Todo: needs survival reqs
  def skeleCave
    return true
  end
  
  def monasteryUpper
    hasItem("Magnes") || hasFlight()
  end
  
  def monasteryFoolRing
    monasteryUpper() && highJump()
  end
  
  #May add more solutions. Logic does not need to account for every solution, only what the game would expect.
  def cubusPuzzle
    @options[:rv_puzzle_progression] && hasFire() && monasteryUpper()
  end
  
end
  