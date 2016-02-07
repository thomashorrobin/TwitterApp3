class AddPartyToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :party_affiliation, index: true, foreign_key: true
  end
end
