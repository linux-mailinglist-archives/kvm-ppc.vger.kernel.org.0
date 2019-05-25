Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E012A3F1
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 13:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEYLIa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 May 2019 07:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfEYLIa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 25 May 2019 07:08:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2D22085A;
        Sat, 25 May 2019 11:08:28 +0000 (UTC)
Date:   Sat, 25 May 2019 07:08:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Remove some notrace RCU APIs
Message-ID: <20190525070826.16f76ee7@gandalf.local.home>
In-Reply-To: <20190525081444.GC197789@google.com>
References: <20190524234933.5133-1-joel@joelfernandes.org>
        <20190524232458.4bcf4eb4@gandalf.local.home>
        <20190525081444.GC197789@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 25 May 2019 04:14:44 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> > I guess the difference between the _raw_notrace and just _raw variants
> > is that _notrace ones do a rcu_check_sparse(). Don't we want to keep
> > that check?  
> 
> This is true.
> 
> Since the users of _raw_notrace are very few, is it worth keeping this API
> just for sparse checking? The API naming is also confusing. I was expecting
> _raw_notrace to do fewer checks than _raw, instead of more. Honestly, I just
> want to nuke _raw_notrace as done in this series and later we can introduce a
> sparse checking version of _raw if need-be. The other option could be to
> always do sparse checking for _raw however that used to be the case and got
> changed in http://lists.infradead.org/pipermail/linux-afs/2016-July/001016.html

What if we just rename _raw to _raw_nocheck, and _raw_notrace to _raw ?

-- Steve
