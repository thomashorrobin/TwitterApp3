class CreatePartyAffiliations < ActiveRecord::Migration
  def change
    create_table :party_affiliations do |t|
      t.string :partyAffiliation
      t.string :partyColour

      t.timestamps null: false
    end
  end
end
