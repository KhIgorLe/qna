class AddAssociationToUsersQuestionsAnswers < ActiveRecord::Migration[5.2]
  def change
    change_table :questions do |t|
      t.references :user, foreign_key: true, null: false
    end

    change_table :answers do |t|
      t.references :user, foreign_key: true, null: false
    end
  end
end
