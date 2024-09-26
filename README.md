
## Overview
The `RentPayment` class is designed to manage rent payment schedules, handle rent changes over time, and accommodate different payment methods with varying processing times. It calculates payment dates based on the provided rent details and allows for the addition of rent changes.

## Installation
Make sure you have Ruby installed on your machine.

Clone the repository into your project.
```
git clone git@github.com:edimeer/rent_payment.git
```

## Usage
### Creating a RentPayment Instance
To create an instance of the RentPayment class, provide a hash with the following keys:
- `amount`: The amount of rent (numeric).
- `frequency`: The payment frequency (`"weekly"`, `"fortnightly"`, or `"monthly"`).
- `start_date`: The start date of the rent payments (string, format: `"YYYY-MM-DD"`).
- `end_date`: The end date of the rent payments (string, format: `"YYYY-MM-DD"`).
- `payment_method` (optional): The payment method used (`"credit_card"`, `"bank_transfer"`, or `"instant"`).

```
rent = {
  amount: 1000,
  frequency: 'monthly',
  start_date: '2024-01-01',
  end_date: '2024-04-01'
}

rent_payment = RentPayment.new(rent)
```

### Adding Rent Changes
You can add rent changes using the `add_rent_change` method. This method takes a hash with the following keys:
- `amount`: The amount of rent (numeric).
- `effective_date`: The date the new amount becomes effective (string, format: `"YYYY-MM-DD"`).
```
rent_change = {
  amount: 1200,
  effective_date: '2024-02-15'
}

rent_payment.add_rent_change(rent_change)
```

### Calculating Payment Dates
To calculate the payment dates based on the rent details and any changes, use the `payment_dates` method. This method returns an array of payment dates with the corresponding amounts, considering the payment method and processing time.
```
payment_dates = rent_payment.payment_dates
puts payment_dates
```
### Example Usage
Here’s a complete example that demonstrates creating a `RentPayment` instance, adding a rent change, and retrieving payment dates:

```
# Test Scenarios
puts "Scenario 1: Basic Rent Calculation"
rent = {
  amount: 1000,
  frequency: "monthly",
  start_date: "2024-01-01",
  end_date: "2024-04-01"
}
rent_payment = RentPayment.new(rent)
puts rent_payment.payment_dates

puts "\nScenario 2: Rent Change"
rent_change = {
  amount: 1200,
  effective_date: "2024-02-15"
}
rent_payment.add_rent_change(rent_change)
puts rent_payment.payment_dates

puts "\nScenario 3: Different Payment Method"
rent_with_method = {
  amount: 1000,
  frequency: "monthly",
  start_date: "2024-01-01",
  end_date: "2024-04-01",
  payment_method: "credit_card"
}
rent_payment_with_method = RentPayment.new(rent_with_method)
puts rent_payment_with_method.payment_dates
```
### Output
```
Scenario 1: Basic Rent Calculation
["2024-01-01", "2024-02-01", "2024-03-01"]

Scenario 2: Rent Change
[{:payment_date=>"2024-01-01", :amount=>1000}, {:payment_date=>"2024-02-01", :amount=>1000}, {:payment_date=>"2024-03-01", :amount=>1200}]

Scenario 3: Different Payment Method
[{:payment_date=>"2024-01-03", :amount=>1000, :method=>"credit_card"}, {:payment_date=>"2024-02-03", :amount=>1000, :method=>"credit_card"}, {:payment_date=>"2024-03-03", :amount=>1000, :method=>"credit_card"}]
```
### Error Handling
The class will raise errors for the following situations:
- **Unknown Payment Frequency**: If an unknown frequency is provided, an error will be raised.
- **Unknown Payment Method**: If an unknown payment method is provided, an error will be raised.
- **End Date Before Start Date**: If the end date is before the start date, the method will return an empty array.

### Running Tests
To ensure the class works as expected, you can run the provided RSpec tests. Make sure you have RSpec installed, then run:
```
rspec spec/rent_payment_spec.rb
```
