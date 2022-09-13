from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from ..models import ReceiptDetail
from ..pagination import GenericPagination
from ..serializers import ReceiptDetailSerializer


class ReceiptDetailListView(APIView):
    def get(self, request, *args, **kwargs):
        """
        Retrieve the registered receiptDetails.
        """
        receiptDetails = ReceiptDetail.objects.all()
        receiptDetail_serializer = ReceiptDetailSerializer(receiptDetails, many=True)
        paginator = GenericPagination()
        page_receiptDetail_list = paginator.paginate_queryset(receiptDetail_serializer.data, self.request, view=self)
        return paginator.get_paginated_response(page_receiptDetail_list)

    def post(self, request, *args, **kwargs):
        """
        Create a receiptDetail.
        """
        serializer = ReceiptDetailSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ReceiptDetailView(APIView):
    """
    Retrieve, update or delete a receiptDetail instance.
    """

    def get_object(self, pk):
        try:
            return ReceiptDetail.objects.get(pk=pk)
        except ReceiptDetail.DoesNotExist:
            raise NotFound("NOT_FOUND")

    def get(self, request, pk, *args, **kwargs):
        """
        Retrieve a receiptDetail by ID.
        """
        receiptDetail = self.get_object(pk)
        serializer = ReceiptDetailSerializer(receiptDetail)
        return Response(serializer.data)

    def put(self, request, pk, *args, **kwargs):
        """
        Update a receiptDetail by ID.
        """
        receiptDetail = self.get_object(pk)
        receiptDetail.id = pk
        serializer = ReceiptDetailSerializer(receiptDetail, data=request.data)
        if serializer.is_valid():
            return Response(serializer.data)

    def delete(self, request, pk, *args, **kwargs):
        """
        Delete a receiptDetail by ID.
        """
        self.get_object(pk).delete()
        return Response("OK", status=status.HTTP_204_NO_CONTENT)
