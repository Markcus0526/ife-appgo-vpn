package com.github.shadowsocks.utils

import android.support.v7.util.SortedList
import com.appgo.appgopro.AppGoApplication.Companion.app


/**
 * Wrapper for kotlin.concurrent.thread that tracks uncaught exceptions.
 */
fun thread(name: String? = null, start: Boolean = true, isDaemon: Boolean = false,
           contextClassLoader: ClassLoader? = null, priority: Int = -1, block: () -> Unit): Thread {
    val thread = kotlin.concurrent.thread(false, isDaemon, contextClassLoader, name, priority, block)
    thread.setUncaughtExceptionHandler(app::track)
    if (start) thread.start()
    return thread
}


private class SortedListIterable<out T>(private val list: SortedList<T>) : Iterable<T> {
    override fun iterator(): Iterator<T> = SortedListIterator(list)
}
private class SortedListIterator<out T>(private val list: SortedList<T>) : Iterator<T> {
    private var count = 0
    override fun hasNext() = count < list.size()
    override fun next(): T = if (hasNext()) list[count++] else throw NoSuchElementException()
}
fun <T> SortedList<T>.asIterable(): Iterable<T> = SortedListIterable(this)
