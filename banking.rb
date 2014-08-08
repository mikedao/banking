class Credit
  attr_reader :name

  def initialize(name)
    @name = name # Name of credit card
    @credit_accounts = [] # Sets up an array which will hold the people that have accounts
    @office_space_fund = 0
    puts "#{name} was just created."
  end

  def open_credit(person, limit, rate)
    puts "#{person.name}, thanks for opening an #{@name} credit card."
    puts "Your credit limit is #{limit}."
    puts "Your credit rate is #{rate} percent."
    @credit_accounts.push(person) # Adds person to array of people who have Credit Cards
    person.cc_account.store(@name, [limit, 0, rate]) # Adds a hash - name, credit limit, and balance and rate, and office space fund
  end

  def cc_spend(person, amount)
    if amount > person.cc_account[@name].first # Making sure user is not going over credit limit
        puts "You are trying to spend #{amount}. That is over your limit of #{person.cc_account[@name][0]}."
      else
        person.cc_account[@name][0] -= amount # Removing amount from credit limit
        person.cc_account[@name][1] += amount # Adding amount to balance
        puts "You just spent #{amount}. Your new limit is #{person.cc_account[@name][0]}."
    end

  end

  def cc_pay(person, amount)
    if amount > person.cc_account[@name][1] # Making sure user is not paying over balance
      puts "You are trying to pay #{amount}, which is over your balance of #{person.cc_account[@name][1]}."
    else
      person.cc_account[@name][0] += amount # Adding amount to credit limit
      person.cc_account[@name][1] -= amount # Removing amount from balance
      puts "You just paid #{amount}. Your new limit is #{person.cc_account[@name][0]}."
      puts "Your balance is now #{person.cc_account[@name][1]}."
    end

  end

  def calc_interest(person) # In case we need to calculate interest for a single person.
    puts "Calculating interest. Rate is #{person.cc_account[@name][2]}."
    interest = person.cc_account[@name][1] * person.cc_account[@name][2] # Figuring out how much interest for the balance
    interest = (interest*100).round / 100.0 # Multiplying by 100 and then rounding to get a whole number then dividing by 100.0 to get the two decimal points desired.
    puts "Interest accrued is #{interest}."
    person.cc_account[@name][0] -= interest # Taking amount of interest from the credit limit
    person.cc_account[@name][1] += interest # Adding the interest accrued to the balance
    puts "New credit limit is: #{person.cc_account[@name][0]}"
    puts "New balance is: #{person.cc_account[@name][1]}"

  end

  def interest_everybody()

    @credit_accounts.each do |person| # Loop to iterate through all account holders and take their balance and add it to the total
      puts "Calculating interest for #{person.name}. Rate is #{person.cc_account[@name][2]}."
      interest = person.cc_account[@name][1] * person.cc_account[@name][2] # Figuring out how much interest for the balance
      rounded_interest = (interest*100).ceil / 100.0 # Multiplying by 100 and then rounding to get a whole number then dividing by 100.0 to get the two decimal points desired.
      free_money = rounded_interest - interest # It feels good to be a gangster.
      @office_space_fund += free_money
      puts "Interest accrued is #{interest}."
      person.cc_account[@name][0] -= rounded_interest # Taking amount of interest from the credit limit
      person.cc_account[@name][1] += rounded_interest # Adding the interest accrued to the balance
      puts "New credit limit is: #{person.cc_account[@name][0]}"
      puts "New balance is: #{person.cc_account[@name][1]}"
    end

  end

  def superman_3()
    # No decimal point errors here.
    puts "Office Space Fund is currently at: #{@office_space_fund}"
  end


end

class Bank
  attr_reader :name

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
    person.banks_and_balances[destination.name] += amount # Adds transfer amount to destination bank's balance
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
  attr_accessor :cash, :banks_and_balances, :cc_account
  attr_reader :name

  def initialize(name, cash)
    @cash = cash # Sets how much cash a person has when they are created.
    @name = name # Sets name on creation.
    @banks_and_balances = {} #Sets up hash to contain banks and balances.
    @cc_account = {}
    puts "Hi, #{name}. You have $#{cash}!"
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

amex = Credit.new("AMEX")
amex.open_credit(me, 100, 0.05)
amex.open_credit(friend1, 500, 0.075)
amex.cc_spend(me, 50)
amex.cc_spend(me, 5000)
amex.cc_spend(friend1, 125)
amex.cc_pay(me, 5000)
amex.cc_pay(me, 50)

amex.cc_spend(me, 75) # Have to have a balance to make interest on it!
amex.interest_everybody
amex.superman_3
