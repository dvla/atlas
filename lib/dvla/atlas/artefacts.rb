#typed: strict

require 'sorbet-runtime'

module DVLA
  module Atlas
    class Artefacts
      extend T::Sig

      sig { params(vargs: String, kwargs: T.untyped).void }
      def define_fields(*vargs, **kwargs)
        vargs.each do |attr|
          initialise_fields(attr)
        end

        kwargs.each_pair do |key, value|
          initialise_fields(key)
          send(:"#{key}=", value) # As an initial value has been passed for this field, we want to set it using the newly defined setter
        end
      end

    private

      sig { params(name: T.any(String, Symbol)).void }
      def initialise_fields(name)
        # Create the history of the newly defined field. This will start out empty. There is no public way to set this so
        # no need to expose it by defining a method.
        instance_variable_set("@#{name}_history", [])

        # Create the getter for the new field, and ensure that it is run upon call if it is a proc.
        define_singleton_method :"#{name}" do
          value = instance_variable_get("@#{name}")
          value.respond_to?(:call) ? value.call : value
        end

        # Define a getter for the history of the new field
        define_singleton_method :"#{name}_history" do
          instance_variable_get("@#{name}_history")
        end

        # Define the setter for the new field. This also pushes the current value of the field into the history unless
        # it is currently nil and the history is empty. This is to prevent each history list starting with a nil entry
        # as all fields are nil when defined.
        define_singleton_method :"#{name}=" do |arg|
          current_value = send(:"#{name}")
          send(:"#{name}_history").push(current_value) unless send(:"#{name}_history").empty? && current_value.nil?
          instance_variable_set("@#{name}", arg)
        end
      end
    end
  end
end
