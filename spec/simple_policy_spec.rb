# frozen_string_literal: true

RSpec.describe PolicyCheck do
  describe "inline policy" do
    let(:klass) do
      klass = Struct.new(:value)
      klass.class_exec { extend PolicyCheck } # rubocop:disable RSpec/DescribedClass

      klass
    end

    let(:instance) do
      klass.class_exec do
        policy :my_policy do
          error("value is `1`") { value == 1 }
        end
      end

      klass.new
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

  describe "Policy class" do
    let(:klass) do
      klass = Class.new
      klass.class_exec { extend PolicyCheck } # rubocop:disable RSpec/DescribedClass

      klass
    end

    let(:instance) do
      klass.class_exec do
        attr_accessor :value

        policy do
          error("value is `1`") { value == 1 }
        end
      end

      klass.new
    end

    context "when an error occurs" do
      it do
        instance.value = 1
        expect(instance).not_to be_valid
      end

      it do
        instance.value = 1
        expect(instance).to be_invalid
      end

      it do
        instance.value = 1
        expect(instance).to have_attributes(error_messages: ["value is `1`"])
      end
    end

    context "when a no error occurs" do
      it do
        instance.value = 2
        expect(instance).to be_valid
      end

      it do
        instance.value = 2
        expect(instance).not_to be_invalid
      end

      it do
        instance.value = 2
        expect(instance).to have_attributes(error_messages: be_empty)
      end
    end
  end
end
