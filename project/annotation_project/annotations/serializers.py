from rest_framework import serializers
from .models import Annotation

class AnnotationSerializer(serializers.ModelSerializer):
    target = serializers.SerializerMethodField()

    class Meta:
        model = Annotation
        fields = ['id', 'type', 'body', 'target']

    def get_target(self, obj):
        return {
            'source': obj.target_source,
            'selector': {
                'type': obj.target_selector_type,
                'start': obj.target_selector_start,
                'end': obj.target_selector_end,
            }
        }

    def create(self, validated_data):
        target_data = validated_data.pop('target')
        annotation = Annotation.objects.create(**validated_data)

        # Extract values from the nested target field
        target_selector_data = target_data['selector']
        annotation.target_source = target_data['source']
        annotation.target_selector_type = target_selector_data['type']
        annotation.target_selector_start = target_selector_data['start']
        annotation.target_selector_end = target_selector_data['end']

        annotation.save()

        return annotation
