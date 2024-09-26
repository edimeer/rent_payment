require './rent_payment'

RSpec.describe RentPayment do
  let(:rent) { { amount: 1000, frequency: 'monthly', start_date: '2024-01-01', end_date: '2024-04-01' } }
  let(:rent_payment) { RentPayment.new(rent) }

  describe '#initialize' do
    it 'initializes with the provided rent details' do
      expect(rent_payment.rent).to eq(rent)
      expect(rent_payment.rent_changes).to eq([])
    end
  end

  describe '#add_rent_change' do
    it 'adds and sorts rent changes by effective date' do
      rent_change = { amount: 1200, effective_date: '2024-02-15' }
      rent_payment.add_rent_change(rent_change)

      expect(rent_payment.rent_changes).to include(rent_change)
      expect(rent_payment.rent_changes.first[:effective_date]).to eq('2024-02-15')
    end
  end

  describe '#payment_dates' do
    context 'with no changes and no payment method' do
      it 'returns an array of payment dates' do
        expect(rent_payment.payment_dates).to eq(["2024-01-01", "2024-02-01", "2024-03-01"])
      end
    end

    context 'with rent changes' do
      before do
        rent_change = { amount: 1200, effective_date: '2024-02-15' }
        rent_payment.add_rent_change(rent_change)
      end

      it 'returns payment dates with the correct amounts' do
        expect(rent_payment.payment_dates).to eq([
          { payment_date: "2024-01-01", amount: 1000 },
          { payment_date: "2024-02-01", amount: 1000 },
          { payment_date: "2024-03-01", amount: 1200 }
        ])
      end
    end

    context 'when using a payment method' do
      let(:rent_with_method) { rent.merge(payment_method: 'credit_card') }
      let(:rent_payment_with_method) { RentPayment.new(rent_with_method) }

      it 'returns payment dates with the correct method and amounts' do
        expect(rent_payment_with_method.payment_dates).to eq([
          { payment_date: "2024-01-03", amount: 1000, method: "credit_card" },
          { payment_date: "2024-02-03", amount: 1000, method: "credit_card" },
          { payment_date: "2024-03-03", amount: 1000, method: "credit_card" }
        ])
      end
    end

    context 'when the end date is before the start date' do
      let(:invalid_rent) { { amount: 1000, frequency: 'monthly', start_date: '2024-04-01', end_date: '2024-01-01' } }
      let(:invalid_rent_payment) { RentPayment.new(invalid_rent) }

      it 'returns an empty array' do
        expect(invalid_rent_payment.payment_dates).to eq([])
      end
    end

    context 'with an unknown frequency' do
      let(:invalid_rent) { { amount: 1000, frequency: 'daily', start_date: '2024-01-01', end_date: '2024-01-31' } }
      let(:invalid_rent_payment) { RentPayment.new(invalid_rent) }

      it 'raises an error' do
        expect { invalid_rent_payment.payment_dates }.to raise_error(RuntimeError, "Unknown frequency: daily")
      end
    end
  end
end
