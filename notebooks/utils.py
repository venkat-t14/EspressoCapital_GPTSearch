import re
import sseclient
import tiktoken


def content_generator(content: str, chunk_size=5):
    enc = tiktoken.encoding_for_model("gpt-4")
    encoded_text = enc.encode(content)
    for i in range(0, len(encoded_text), chunk_size):

        delta = json.dumps(dict(content=enc.decode(encoded_text[i : i + chunk_size])))

        print(f"data: {delta}\n")

    print("data: [DONE]\n")

def parse_stream_output(response):
    sse_client = sseclient.SSEClient(response)
    for event in sse_client.events():
        if event.data != "[DONE]":
            print(f"data: {event.data}\n")
        else:
            print("data: [DONE]\n")