import threading
import time

lock = threading.Lock()

def worker():
    with lock:
        print('[WORKER {}] sleeps'.format(threading.get_ident()))
    time.sleep(1)
    with lock:
        print('[WORKER {}] doesnt sleep'.format(threading.get_ident()))


start_measure = time.time()

thread1 = threading.Thread(target=worker)
thread2 = threading.Thread(target=worker)

thread1.start()
thread2.start()
thread1.join()
thread2.join()
stop_measure = time.time()

print('Finished in {} seconds'.format(round(stop_measure - start_measure), 2))
