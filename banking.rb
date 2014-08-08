class Bank
  attr_accessor :name


  def initialize(name)
    @name = name    # Holds name of bank
    @accounts = []  # Sets up an array which will hold the people that have accounts
    puts "#{name} was just created."
  end

  def open_account(person)
    puts "#{person.name}, thanks for opening an account at #{@name}"
    @accounts.push(person) # Adds person who created account to the array of account holders for this bank only
    person.banks_and_balances.store(@name, 0) # Adds to a hash in the person object that holds bank name and their current balance

  end

  def withdraw(person, amount)

    if amount > person.banks_and_balances[@name] # Checks to see if balance is sufficient for withdrawal
      puts "#{person.name} does not have enough money in the account to withdraw $#{amount}"
    else
      person.cash = person.cash + amount # Adds withdrawal amount to cash
      person.banks_and_balances[@name] -= amount # Removes withdrawal amount from balance
      puts "#{person.name} withdrew $#{amount} to #{@name}. #{person.name} has $#{person.cash} #{person.name}'s account has $#{person.banks_and_balances[@name]}"
    end

  end

  def deposit(person, amount)

    if amount > person.cash # Checks to see if cash is sufficient for deposit
      puts "#{person.name} does not have enough cash to deposit $#{amount}"
    else
      person.cash = person.cash - amount # Removes deposit amount from cash
      person.banks_and_balances[@name] += amount # Adds deposit amount to balance
      puts "#{person.name} deposited $#{amount} to #{@name}. #{person.name} has $#{person.cash} #{person.name}'s account has $#{person.banks_and_balances[@name]}"
    end

  end

  def transfer(person, destination, amount)

    person.banks_and_balances[@name] -= amount # Removes transfer amount from originating bank's balance.
    person.banks_and_balances[destination.name] += amount # Adds transfer amount to destination bank's balance.


    puts "#{person.name} transferred $#{amount} from the #{@name} account to the #{destination.name} account."
    puts "The #{@name} account has $#{person.banks_and_balances[@name]} and the #{destination.name} account has $#{person.banks_and_balances[destination.name]}"
  end

  def total_cash_in_bank()
    total = 0
    @accounts.each do |person| # Loop to iterate through all account holders and take their balance and add it to the total
      account_balance = person.banks_and_balances[@name]
      total += account_balance
    end
    return "#{@name} has $#{total} in the bank."

  end




end


class Person
  attr_accessor :cash
  attr_reader :name
  attr_accessor :banks_and_balances

  def initialize(name, cash)
    @cash = cash # Sets how much cash a person has when they are created.
    @name = name # Sets name on creation.
    @banks_and_balances = {} #Sets up hash to contain banks and balances.
    puts "Hi, #{name}. You have $#{cash}!"
  end

  def init_credit(credit_limit)
    @credit_limit = credit_limit
    @balance = 0
    puts "Initializing credit card for #{@name} with a limit of $#{@credit_limit}."
  end

  def credit_spend(amount)
    if amount > @credit_limit
      puts "Charge Denied"
    else
      @credit_limit -= amount
      @balance += amount
      puts "You just spent $#{amount}. Your balance is $#{@balance} and your limit is $#{@credit_limit}."
    end
  end

  def credit_pay(amount)
    if amount > @balance
      puts "You are paying more than your balance. Please only pay the balance."
    else

      @credit_limit += amount
      @balance -= amount
      puts "You just paid $#{amount}. Your current balance is $#{@balance} and your limit is $#{@credit_limit}"
    end
  end
  


end





chase = Bank.new("JP Morgan Chase")
wells_fargo = Bank.new("Wells Fargo")
me = Person.new("Shehzan", 500)
friend1 = Person.new("John", 1000)
chase.open_account(me)
chase.open_account(friend1)
wells_fargo.open_account(me)
wells_fargo.open_account(friend1)
chase.deposit(me, 200)
chase.deposit(friend1, 300)
chase.withdraw(me, 50)
chase.transfer(me, wells_fargo, 100)

chase.deposit(me, 5000)
chase.withdraw(me, 5000)

puts chase.total_cash_in_bank
puts wells_fargo.total_cash_in_bank

me.init_credit(100)
me.credit_spend(50)
me.credit_spend(5000)
me.credit_pay(5000)
me.credit_pay(10)
