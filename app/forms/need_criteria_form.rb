class NeedCriteriaForm < Rectify::Form
  class CriterionForm < Rectify::Form
    attribute :value
  end

  mimic :need
  attribute :criteria, Array[CriterionForm]

  def map_model(model)
    self.criteria = model.met_when.map {|value|
      CriterionForm.from_params(value: value)
    }
  end

  def criteria_attributes=(attributes)
    self.criteria = attributes.map {|_, item|
      CriterionForm.from_params(item)
    }
  end

  def to_criteria
    self.criteria.map(&:value)
  end
end
