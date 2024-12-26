class OoELogic
  
  def initialize(c, o)
    @checker = c
    @options = o
  end
  
  def hasItem(item)
    @checker.current_items.include?(item)
  end

  def hasItemLine(base)
    hasItem(base) || hasItem("Vol " + base) || hasItem("Melio " + base)
  end

  def gearExceeds(n)
    @checker.gear_level >= n
  end
  
  def villagerCount(n)
    return true #todo
  end
  
  def hasSlash
    hasItemLine("Confodere") || hasItemLine("Secare") || hasItemLine("Hasta") || hasItemLine("Falcis") || hasItem("Arma Felix") || hasItem("Arma Chiroptera")
  end

  def hasStrike
    hasItemLine("Macir") || hasItem("Lapiste") || hasItem("Globus")
  end

  def hasFire
    hasItem("Ignis") || hasItem("Vol Ignis") || hasItem("Nitesco")
  end

  def hasIce
    hasItem("Grando") || hasItem("Vol Grando")
  end

  def hasLightning
    hasItem("Vol Fulgur") || hasItem("Fulgur") || hasItem("Acerbatus")
  end
  
  #Light is considered progression to beat castle bosses after Blackmore, unless you pick the hardest difficulty.
  def hasLight
    hasItem("Luminatio") || hasItem("Vol Luminatio") || hasItem("Nitesco")
  end

  def hasDark
    hasItem("Vol Umbra") || hasItem("Morbus") || hasItem("Acerbatus")
  end
  
  def hasFlight
    if @options[:rv_difficulty] == "Vanilla"
      hasItem("Volaticus")
    else
      hasItem("Volaticus") || (hasItem("Redire") && hasItem("Magnes"))
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
      || (@options[:rv_difficulty] != "Vanilla" && (hasItem("Arma Felix") || hasItem("Arma Chiroptera"))) \
      || hasItem("Magnes") || hasItem("Arma Machina")
  end
  
  def smallDistance()
    catTackle() || speedBoots() || midDistance() || (@options[:rv_difficulty] == "Do Your Worst" && hasItem("Arma Chiroptera"))
  end
  
  def midDistance()
    ( catTackle() && ( hasItem("Moonwalkers") || hasItem("Winged Boots") ) ) \
      || farDistance()
  end
  
  def farDistance()
     hasFlight() \
       || ( @options[:rv_difficulty] != "Vanilla"  && hasItem("Rapidus Fio") )
  end
  
  def castleEntry
    highJump() && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(6)) || gearExceeds(12))
  end
  
  def castleEntranceEast
    castleEntry() && hasItem("Paries") && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(9)) || gearExceeds(12))
  end
  
  def beatBlackmore
    castleEntranceEast() && ( hasFire() || hasLight() ) && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(11)) || gearExceeds(14))
  end
  
  def mechTower
    beatBlackmore() && ( hasItem("Magnes") || hasFlight() ) && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(14)) || gearExceeds(16))
  end
  
  def beatDeath
   mechTower() && hasLight()
  end
  
  def fulgurPuzzle
    @options[:rv_puzzle_progression] && mechTower() \
        && hasLightning()
  end
  
  #If you're stubborn you can divekick off the imp to get into Arms Depot...
  #You can't jump out, but there's a teleporter so you can't be locked in.
  def armsDepot
    mechTower() \
      || ( @options[:rv_difficulty] == "Do Your Worst") && beatBlackmore()
  end
  
  #Todo: include logic for the battle itself
  def beatEligor
    armsDepot && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(17)) || gearExceeds(20))
  end
  
  def finalApproach
    castleEntranceEast && (@options[:rv_unlock_cerberus] || (hasItem("Dextro Custos") && hasItem("Sinestro Custos") && hasItem("Arma Custos"))) && (@options[:rv_difficulty] == "Do Your Worst" || gearExceeds(20))
  end
  
  def volaticusAttic
    finalApproach() && hasFlight()
  end
  
  def beatDracula
    hasItem("Dominus Hatred") && hasItem("Dominus Anger") && hasItem("Dominus Agony") \
      && volaticusAttic() && hasLight()
  end
  
  def trainingHall
    case @options[:rv_difficulty]
    when "Vanilla"
      false
    when "Creative"
      hasItem("Magnes") && hasItem("Ordinary Rock") && gearExceeds(10)
    when "Do Your Worst"
      hasItem("Magnes") && ( hasItem("Ordinary Rock") || hasItem("Redire") )
    end
  end
  
  #Masochist logic could allow traveling underwater with Redire's backswing in map rando. In vanilla the only accessible location this creates is the breakable ceiling in Serge's room.
  def underwater
    hasItem("Serpent Scale")
  end
  
  def kalidusDepths
    underwater() && beatCrab() && (@options[:rv_difficulty] != "Vanilla" || gearExceeds(6))
  end

  def somnusWest
    underwater() && (@options[:rv_difficulty] != "Vanilla" || gearExceeds(8))
  end

  def beatRusalka()
    (hasSlash() or hasLightning()) && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(7)) || gearExceeds(10))
  end

  def somnusEast
    somnusWest() && beatRusalka()
  end
  
  #Todo: add crushing/fire damage reqs for easy-level logic
  def beatGiantSkeleton
    (hasItem("Magnes") || highJump()) || @options[:rv_difficulty] == "Do Your Worst" #|| (@options[:rv_difficulty] == "Creative" && gearExceeds(8))) #Temporarily add damageless req in case the player is forced here with weak glyphs
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

  def beatRobot
    mineraEnd && (hasStrike() || hasLightning() || hasFire() || hasLight() || hasIce() || hasDark())
  end
  
  def lighthouse
    crossSpikes() || (@options[:rv_difficulty] != "Vanilla" && (hasItem("Rapidus Fio") || ( highJump() && smallDistance() ) ) )
  end
  
  def beatCrab
    lighthouse() && ( hasItem("Magnes") || highJump() ) && (@options[:rv_difficulty] != "Vanilla" || ((hasStrike() || hasLightning()) && gearExceeds(6)))
  end
  
  def tymeoMidway
    (crossSpikes() || hasFlight()) && (@options[:rv_difficulty] != "Vanilla" || gearExceeds(6))
  end
  
  def tymeoEast
    tymeoMidway() && ( midDistance() || highJump() ) && (@options[:rv_difficulty] != "Vanilla" || gearExceeds(6))
  end
  
  def tymeoParies
    tymeoEast() && hasItem("Paries")
  end
  
  def pneumaPuzzle
    tymeoEast() && hasItem("Magnes")
  end
  
  def tristisWaterfall
    highJump() && hasItem("Magnes") && (@options[:rv_difficulty] != "Vanilla" || gearExceeds(8))
  end
  
  def giantsDwelling
    highJump() && (@options[:rv_difficulty] != "Vanilla" || gearExceeds(8))
  end

  def beatGoliath
    giantsDwelling && (@options[:rv_difficulty] == "Do Your Worst" || (gearExceeds(14) || (gearExceeds(10) && hasSlash())))
  end
  
  def mysteryManor
    (highJump() || smallDistance()) && (@options[:rv_difficulty] == "Do Your Worst" || (@options[:rv_difficulty] == "Creative" && gearExceeds(8)) || gearExceeds(12))
  end
  
  #Todo: include logic for the battle itself
  def beatAlbus
    mysteryManor && (@options[:rv_difficulty] == "Do Your Worst" || (gearExceeds(12) && (hasSlash || hasDark))) && (@options[:rv_unlock_albus] || (kalidusDepths() && tristisWaterfall() && giantsDwelling))
  end
  
  def mistyJumpWest
     farDistance() || ( highJump() && smallDistance() )
  end
  
  def mistyParies
    hasItem("Paries") && (@options[:rv_difficulty] != "Vanilla" || ((hasSlash() || hasFire()) && gearExceeds(8)))
  end
  
  def mistyRoad
    @options[:rv_difficulty] != "Vanilla" || gearExceeds(4)
  end
  
  def mistyJumpEast
    mistyJumpWest() || hasItem("Magnes")
  end
  
  def beatFish
    @options[:rv_difficulty] == "Do Your Worst" || gearExceeds(14) || (gearExceeds(10) && (hasStrike() || hasIce()))
  end
  
  alias oblivionJump mistyJumpWest
  
  def skeleCave
    @options[:rv_difficulty] == "Do Your Worst" || gearExceeds(10) || ((hasStrike() || hasFire() || hasLight()) && gearExceeds(6))
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
  