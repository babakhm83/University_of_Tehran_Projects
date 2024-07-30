import pandas as pd
import numpy as np
import re
import hazm
categories={}
book_categories_cnt={}
words={}
processed_words={}
train_books_address='books_train.csv'
test_books_address='books_test.csv'
stop_words_address='sw.csv'
sw_file=open(stop_words_address, 'r')
stop_words_str=sw_file.read()
stop_words=stop_words_str.split()
_lemmatizer=hazm.Lemmatizer()
_stemmer=hazm.Stemmer()

class book:
    def __init__(self,title,description, category, config):
        self.title=title
        self.description=description
        self.category=category
        self.config=config
        if category not in categories:
            categories[category] = len(categories)
            book_categories_cnt[categories[category]]=0
            book_categories_cnt[categories[category]]+=1
        self.preprocess_data()

    @staticmethod
    def create_books_from_data(file_address):
        pass

    def __advanced_preprocess_data(self):
        if self.config['remove_stop_words'] and not stop_words_address == None:
            self.my_words=[word for word in self.my_words if word not in stop_words]
        for word in self.my_words:
            if word not in processed_words:
                processed_words[word]=word
                if self.config['do_stemmation']:
                    processed_words[word]=_stemmer.stem(word)
                if self.config['do_lemmatization']:
                    processed_words[word]=_lemmatizer.lemmatize(processed_words[word]).split('#')[0]
                if not self.config['do_lemmatization'] and not self.config['do_stemmation']:
                    processed_words[word]=word
            if processed_words[word] not in self.my_processed_word:
                self.my_processed_word[processed_words[word]]=0
            self.my_processed_word[processed_words[word]]+=1

    def preprocess_data(self):
        self.my_processed_word=dict()
        re_pattern="[^آ-ی \u200c]"
        self.description=re.sub(re_pattern,'',self.description)
        self.title=re.sub(re_pattern,'',self.title)
        self.description=self.description.replace('\u200c',' ')
        self.title=self.title.replace('\u200c',' ')
        self.my_words=self.description.split()
        for i in range(self.config['times_to_add_title']):
            self.my_words.extend(self.title.split())
        self.__advanced_preprocess_data()
            
    def update_bow(self):
        for word in self.my_processed_word.keys():
            val=self.my_processed_word[word]
            bow[categories[self.category],words[word]]+=val
            bow[categories[self.category],-1]+=val
            bow[-1,words[word]]+=val
            bow[-1,-1]+=val

class train_book(book):
    @staticmethod
    def create_books_from_data(file_address, config):
        df = pd.read_csv(file_address)
        df_numpy=df.to_numpy()
        df_to_books=lambda x: train_book(x[0],x[1],x[2], config)
        return np.array([df_to_books(val) for val in df_numpy])
    
    def preprocess_data(self):
        book.preprocess_data(self)
        for word in self.my_processed_word.keys():
            if word not in words:
                words[word] = len(words)

class test_book(book):
    @staticmethod
    def create_books_from_data(file_address, config):
        df = pd.read_csv(file_address)
        df_numpy=df.to_numpy()
        df_to_books=lambda x: test_book(x[0],x[1],x[2], config)
        return np.array([df_to_books(val) for val in df_numpy])

    def calculate_probabilities(self):
        self.cat_prob=np.zeros(len(categories))
        for i in range(len(categories)):
            self.cat_prob[i]+=np.log(book_categories_cnt[i]/len(train_books))
            for word in self.my_processed_word.keys():
                if word in words and not bow[i,words[word]]==0:
                    self.cat_prob[i]+= np.log(bow[i,words[word]]/bow[i,-1])
                elif self.config['do_additive_smoothing']:
                    self.cat_prob[i]+=np.log(self.config['additive_smoothing_alpha']/
                                             (bow[i,-1]+self.config['additive_smoothing_alpha']*len(words)))
                elif self.config['no_additive_smoothing_probability']==0:
                    self.cat_prob[i]=0
                    break
            self.cat_prob[i]*=-1

    def guess_the_category(self):
        self.calculate_probabilities()
        self.guessed_category=np.argmin(self.cat_prob)

    def did_you_guess_correctly(self):
        if self.guessed_category==categories[self.category]:
            return True
        return False
    

def calculate_the_precision():
    _precision=0
    for _book in test_books:
        if _book.did_you_guess_correctly():
            _precision+=1
    return _precision*100/len(test_books)


config={'do_additive_smoothing': True, 'no_additive_smoothing_probability':0, 'remove_stop_words':True, 'do_lemmatization':True,
        'do_stemmation':True, 'times_to_add_title':10, 'additive_smoothing_alpha':10.0}
train_books=train_book.create_books_from_data(train_books_address,config)
bow = np.zeros((len(categories)+1,len(words)+1),dtype=np.uintc)
for _book in train_books:
    _book.update_bow()
test_books=test_book.create_books_from_data(test_books_address,config)
for _book in test_books:
    _book.guess_the_category()
print(calculate_the_precision())
sw_file.close()
