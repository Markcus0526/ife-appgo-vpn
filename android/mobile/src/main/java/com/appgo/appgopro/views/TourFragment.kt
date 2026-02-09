package com.appgo.appgopro.views

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import com.appgo.appgopro.R
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.supers.SuperFragment

class TourFragment: SuperFragment() {

    private var contentView: View? = null
    private var startnowBtn: Button? = null

    fun newInstance(layoutId: Int): TourFragment? {
        val pane = TourFragment()
        val args = Bundle()
        args.putInt(TourFragment.LAYOUT_ID, layoutId)
        pane.setArguments(args)
        return pane
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = inflater.inflate(arguments!!.getInt(TourFragment.LAYOUT_ID, -1), container, false) as ViewGroup
        if (contentView == null)
            return null

        if (contentLayout() == R.layout.fragment_welcome3) {
            startnowBtn = contentView!!.findViewById(R.id.startnowBtn)
            startnowBtn!!.setOnClickListener({
                Preference.sharedInstance().saveWelcomeDisable(true)
                (parentActivity as TourActivity).endTutorial()
            })
        }
        return contentView
    }

    override fun contentLayout(): Int {
        return arguments!!.getInt(TourFragment.LAYOUT_ID)
    }

    companion object {
        val LAYOUT_ID = "layoutid"

        protected var instance: TourFragment? = null
        private val TAG = "TourFragment"

        fun sharedInstance(): TourFragment {
            if (instance == null)
                instance = TourFragment()

            return instance as TourFragment
        }
    }
}
