#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============
import sys
reload(sys)
sys.setdefaultencoding('utf-8')


import os
import json
import random


locality = os.getcwd()
faker_data = locality + '/src/Faker/faker_data.json'


def load_data_from_file(file_name):
    with open(file_name) as f:
        data = json.load(f)
        return data

def create_sentence(n=10):
    n = int(n)
    data = load_data_from_file(faker_data)
    words = data['words']
    if n != 1:
        string = " ".join([words[random.randrange(0, len(words))] for _ in range(n)])
        sentence = (string[0].upper() + string[1:] + '.')
        return sentence
    else:
        word = 'd-' + words[random.randrange(0, len(words))] + '.doc'
        return word


def create_fake_doc(n=10):
    n = int(n)
    content = create_sentence(n)
    name = create_sentence(1)
    path = locality + '/test_output/' + name
    f = open(path, 'w+')
    f.write(content.encode('utf8'))
    f.close()
    return path, name, content