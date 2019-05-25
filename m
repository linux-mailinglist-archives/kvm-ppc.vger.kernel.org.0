Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212482A66A
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 20:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfEYSOL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 May 2019 14:14:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42180 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfEYSOL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 May 2019 14:14:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id r22so4328692pfh.9
        for <kvm-ppc@vger.kernel.org>; Sat, 25 May 2019 11:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WMR94oFTY+OqH2rjdVLemgAhQSEwpDtMoTvHog5j0sQ=;
        b=X0CnhJKSN5RJR4iBBE0j8IyN20bJySbgLRYLCC51oQloSv5szaUMYCNZpmOF7YbrDu
         djpT8FbnXBj3XQkIAMR6RR9RpzFcWEVC3LhAMyeOqLUzZjvP8fjtU34iUpZcXld1un1M
         b02atJSdTlxwLlu/aDOH5x6Q5ekm4aDR1+1vE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WMR94oFTY+OqH2rjdVLemgAhQSEwpDtMoTvHog5j0sQ=;
        b=S39LYCN+t9ICYh/tCtECiZj52jzD4R0zz4WiNdbzrXkbSnDDamR0Rw1CdMx3tcxSPi
         sptxjGb2EdHfXLkhaTozJz3rnD3jHkzB3WROU5wAvmoNcR8bpnnTigYinXjYdG3Rv6vj
         jazbSZUuiAWhFZbRgzRJmsFWwD9xDiKd0Ho6iXz/w5KJQTour3Azhjoe/2xutCTQaQZK
         CZ/as+7l1IFRTs5JhL+9uaj5cRhCM1iNN1muGNSwKFif89mF+tecL9NSL1B5rR1KLQsj
         BUtrQHfx4NahZFziCMrJREa8UUL55QznwI3v/KYicUp9xebmPWBEVaU7vkOGCRG4C/nc
         5qhg==
X-Gm-Message-State: APjAAAUhLkME1LiUdcBexOs0TiIS4UNwjafzwtQ2Gz0jEmj2KaWe0bE/
        9XKJQSmlGnGUmylsup4I6t9zfw==
X-Google-Smtp-Source: APXvYqyQRiZeJdnv8NV0jJQ1QNMV+NOKlT6Luw5GwD0AE0gpx9GAm4B91udlCkCjw5QI0crgiiIVzA==
X-Received: by 2002:a63:4710:: with SMTP id u16mr11132086pga.447.1558808050038;
        Sat, 25 May 2019 11:14:10 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y13sm8409814pfb.143.2019.05.25.11.14.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 May 2019 11:14:08 -0700 (PDT)
Date:   Sat, 25 May 2019 14:14:07 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
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
Message-ID: <20190525181407.GA220326@google.com>
References: <20190524234933.5133-1-joel@joelfernandes.org>
 <20190524232458.4bcf4eb4@gandalf.local.home>
 <20190525081444.GC197789@google.com>
 <20190525070826.16f76ee7@gandalf.local.home>
 <20190525141954.GA176647@google.com>
 <20190525155035.GE28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190525155035.GE28207@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 25, 2019 at 08:50:35AM -0700, Paul E. McKenney wrote:
> On Sat, May 25, 2019 at 10:19:54AM -0400, Joel Fernandes wrote:
> > On Sat, May 25, 2019 at 07:08:26AM -0400, Steven Rostedt wrote:
> > > On Sat, 25 May 2019 04:14:44 -0400
> > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > > 
> > > > > I guess the difference between the _raw_notrace and just _raw variants
> > > > > is that _notrace ones do a rcu_check_sparse(). Don't we want to keep
> > > > > that check?  
> > > > 
> > > > This is true.
> > > > 
> > > > Since the users of _raw_notrace are very few, is it worth keeping this API
> > > > just for sparse checking? The API naming is also confusing. I was expecting
> > > > _raw_notrace to do fewer checks than _raw, instead of more. Honestly, I just
> > > > want to nuke _raw_notrace as done in this series and later we can introduce a
> > > > sparse checking version of _raw if need-be. The other option could be to
> > > > always do sparse checking for _raw however that used to be the case and got
> > > > changed in http://lists.infradead.org/pipermail/linux-afs/2016-July/001016.html
> > > 
> > > What if we just rename _raw to _raw_nocheck, and _raw_notrace to _raw ?
> > 
> > That would also mean changing 160 usages of _raw to _raw_nocheck in the
> > kernel :-/.
> > 
> > The tracing usage of _raw_notrace is only like 2 or 3 users. Can we just call
> > rcu_check_sparse directly in the calling code for those and eliminate the APIs?
> > 
> > I wonder what Paul thinks about the matter as well.
> 
> My thought is that it is likely that a goodly number of the current uses
> of _raw should really be some form of _check, with lockdep expressions
> spelled out.  Not that working out what exactly those lockdep expressions
> should be is necessarily a trivial undertaking.  ;-)

Yes, currently where I am a bit stuck is the rcu_dereference_raw()
cannot possibly know what SRCU domain it is under, so lockdep cannot check if
an SRCU lock is held without the user also passing along the SRCU domain. I
am trying to change lockdep to see if it can check if *any* srcu domain lock
is held (regardless of which one) and complain if none are. This is at least
better than no check at all.

However, I think it gets tricky for mutexes. If you have something like:
mutex_lock(some_mutex);
p = rcu_dereference_raw(gp);
mutex_unlock(some_mutex);

This might be a perfectly valid invocation of _raw, however my checks (patch
is still cooking) trigger a lockdep warning becase _raw cannot know that this
is Ok. lockdep thinks it is not in a reader section. This then gets into the
territory of a new rcu_derference_raw_protected(gp, assert_held(some_mutex))
which sucks because its yet another API. To circumvent this issue, can we
just have callers of rcu_dereference_raw ensure that they call
rcu_read_lock() if they are protecting dereferences by a mutex? That would
make things a lot easier and also may be Ok since rcu_read_lock is quite
cheap.

> That aside, if we are going to change the name of an API that is
> used 160 places throughout the tree, we would need to have a pretty
> good justification.  Without such a justification, it will just look
> like pointless churn to the various developers and maintainers on the
> receiving end of the patches.

Actually, the API name change is not something I want to do, it is Steven
suggestion. My suggestion is let us just delete _raw_notrace and just use the
_raw API for tracing, since _raw doesn't do any tracing anyway. Steve pointed
that _raw_notrace does sparse checking unlike _raw, but I think that isn't an
issue since _raw doesn't do such checking at the moment anyway.. (if possible
check my cover letter again for details/motivation of this series).

thanks!

 - Joel

> 							Thanx, Paul
> 
> > thanks, Steven!
> > 
> 
