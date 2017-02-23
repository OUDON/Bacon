class ProblemSource < ApplicationRecord
  validates :problem_source, uniqueness: true
end
