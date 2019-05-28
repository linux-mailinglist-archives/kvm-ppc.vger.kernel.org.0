Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4B2C665
	for <lists+kvm-ppc@lfdr.de>; Tue, 28 May 2019 14:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfE1MYw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 28 May 2019 08:24:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726620AbfE1MYw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 28 May 2019 08:24:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SCMbIS125736
        for <kvm-ppc@vger.kernel.org>; Tue, 28 May 2019 08:24:50 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ss3mfuh78-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 28 May 2019 08:24:50 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 28 May 2019 13:24:49 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 28 May 2019 13:24:43 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4SCOgvP29491484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 12:24:43 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2B1FB206E;
        Tue, 28 May 2019 12:24:42 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 994BFB2065;
        Tue, 28 May 2019 12:24:42 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.70.82.216])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 28 May 2019 12:24:42 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id C799516C35C0; Tue, 28 May 2019 05:24:47 -0700 (PDT)
Date:   Tue, 28 May 2019 05:24:47 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Remove some notrace RCU APIs
Reply-To: paulmck@linux.ibm.com
References: <20190524234933.5133-1-joel@joelfernandes.org>
 <20190524232458.4bcf4eb4@gandalf.local.home>
 <20190525081444.GC197789@google.com>
 <20190525070826.16f76ee7@gandalf.local.home>
 <20190525141954.GA176647@google.com>
 <20190525155035.GE28207@linux.ibm.com>
 <20190525181407.GA220326@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190525181407.GA220326@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19052812-0072-0000-0000-00000434284E
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011175; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01209781; UDB=6.00635551; IPR=6.00990810;
 MB=3.00027084; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-28 12:24:48
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052812-0073-0000-0000-00004C6504FA
Message-Id: <20190528122447.GS28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280081
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 25, 2019 at 02:14:07PM -0400, Joel Fernandes wrote:
> On Sat, May 25, 2019 at 08:50:35AM -0700, Paul E. McKenney wrote:
> > On Sat, May 25, 2019 at 10:19:54AM -0400, Joel Fernandes wrote:
> > > On Sat, May 25, 2019 at 07:08:26AM -0400, Steven Rostedt wrote:
> > > > On Sat, 25 May 2019 04:14:44 -0400
> > > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > > > 
> > > > > > I guess the difference between the _raw_notrace and just _raw variants
> > > > > > is that _notrace ones do a rcu_check_sparse(). Don't we want to keep
> > > > > > that check?  
> > > > > 
> > > > > This is true.
> > > > > 
> > > > > Since the users of _raw_notrace are very few, is it worth keeping this API
> > > > > just for sparse checking? The API naming is also confusing. I was expecting
> > > > > _raw_notrace to do fewer checks than _raw, instead of more. Honestly, I just
> > > > > want to nuke _raw_notrace as done in this series and later we can introduce a
> > > > > sparse checking version of _raw if need-be. The other option could be to
> > > > > always do sparse checking for _raw however that used to be the case and got
> > > > > changed in http://lists.infradead.org/pipermail/linux-afs/2016-July/001016.html
> > > > 
> > > > What if we just rename _raw to _raw_nocheck, and _raw_notrace to _raw ?
> > > 
> > > That would also mean changing 160 usages of _raw to _raw_nocheck in the
> > > kernel :-/.
> > > 
> > > The tracing usage of _raw_notrace is only like 2 or 3 users. Can we just call
> > > rcu_check_sparse directly in the calling code for those and eliminate the APIs?
> > > 
> > > I wonder what Paul thinks about the matter as well.
> > 
> > My thought is that it is likely that a goodly number of the current uses
> > of _raw should really be some form of _check, with lockdep expressions
> > spelled out.  Not that working out what exactly those lockdep expressions
> > should be is necessarily a trivial undertaking.  ;-)
> 
> Yes, currently where I am a bit stuck is the rcu_dereference_raw()
> cannot possibly know what SRCU domain it is under, so lockdep cannot check if
> an SRCU lock is held without the user also passing along the SRCU domain. I
> am trying to change lockdep to see if it can check if *any* srcu domain lock
> is held (regardless of which one) and complain if none are. This is at least
> better than no check at all.
> 
> However, I think it gets tricky for mutexes. If you have something like:
> mutex_lock(some_mutex);
> p = rcu_dereference_raw(gp);
> mutex_unlock(some_mutex);
> 
> This might be a perfectly valid invocation of _raw, however my checks (patch
> is still cooking) trigger a lockdep warning becase _raw cannot know that this
> is Ok. lockdep thinks it is not in a reader section. This then gets into the
> territory of a new rcu_derference_raw_protected(gp, assert_held(some_mutex))
> which sucks because its yet another API. To circumvent this issue, can we
> just have callers of rcu_dereference_raw ensure that they call
> rcu_read_lock() if they are protecting dereferences by a mutex? That would
> make things a lot easier and also may be Ok since rcu_read_lock is quite
> cheap.

Why not just rcu_dereference_protected(lockdep_is_held(some_mutex))?
The API is already there, and no need for spurious readers.

> > That aside, if we are going to change the name of an API that is
> > used 160 places throughout the tree, we would need to have a pretty
> > good justification.  Without such a justification, it will just look
> > like pointless churn to the various developers and maintainers on the
> > receiving end of the patches.
> 
> Actually, the API name change is not something I want to do, it is Steven
> suggestion. My suggestion is let us just delete _raw_notrace and just use the
> _raw API for tracing, since _raw doesn't do any tracing anyway. Steve pointed
> that _raw_notrace does sparse checking unlike _raw, but I think that isn't an
> issue since _raw doesn't do such checking at the moment anyway.. (if possible
> check my cover letter again for details/motivation of this series).

Understood, but regardless of who suggested it, if we are to go through
with it, good justification will be required.  ;-)

							Thanx, Paul

> thanks!
> 
>  - Joel
> 
> > 							Thanx, Paul
> > 
> > > thanks, Steven!
> > > 
> > 
> 

