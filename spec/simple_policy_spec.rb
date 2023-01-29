# frozen_string_literal: true

RSpec.describe SimplePolicy do
  let(:klass) do
    klass = Struct.new(:value)
    klass.class_exec { extend SimplePolicy } # rubocop:disable RSpec/DescribedClass

    klass
  end

  let(:instance) { klass.new }

  context "when defined in a block" do
    before do
      klass.class_exec do
        policy :my_policy do
          error("value is `1`") { value == 1 }
        end
      end
    end

    context "when an error occurs" do
      it do
        instance.value = 1
        expect(instance).not_to be_my_policy
      end

      it do
        instance.value = 1
        expect(instance).to have_attributes(my_policy_errors: ["value is `1`"])
      end
    end

    context "when a no error occurs" do
      it do
        instance.value = 2
        expect(instance).to be_my_policy
      end

      it do
        instance.value = 2
        expect(instance).to have_attributes(my_policy_errors: be_empty)
      end
    end
  end

  context "when defined in a `&:`" do
    before do
      klass.class_exec do
        def value_is_one?
          value == 1
        end

        policy :my_policy do
          error "value is `1`", &:value_is_one?
        end
      end
    end

    context "when an error occurs" do
      it do
        instance.value = 1
        expect(instance).not_to be_my_policy
      end

      it do
        instance.value = 1
        expect(instance).to have_attributes(my_policy_errors: ["value is `1`"])
      end
    end

    context "when a no error occurs" do
      it do
        instance.value = 2
        expect(instance).to be_my_policy
      end

      it do
        instance.value = 2
        expect(instance).to have_attributes(my_policy_errors: be_empty)
      end
    end
  end
end
