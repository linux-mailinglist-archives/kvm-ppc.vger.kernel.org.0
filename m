Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7A32A677
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 20:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfEYSSV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 May 2019 14:18:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38308 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfEYSSV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 May 2019 14:18:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so7206514pfb.5
        for <kvm-ppc@vger.kernel.org>; Sat, 25 May 2019 11:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pwUwT3IH5HpGo/L8sP6//cCZtClp5/ip6vUnZdkkz+4=;
        b=kkcebdlaAxI4tg4ycJmEqrzHnyewgh+jjzD8JuWykQMD1lxIZbs14DxRaS3JzJWrkx
         D3zUk40qEzDf9b4/+3m3e4ZQvAeZltgNBFxxlJjzMPDywJcvPdcoFqhPgZYDwqU6gPKo
         ZKBP/5ISTo1G00dTfWL1Nmxp2HkYKifVw8IVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pwUwT3IH5HpGo/L8sP6//cCZtClp5/ip6vUnZdkkz+4=;
        b=s6LRFaHBWBq2SnycSDLDBSctwUIL5GcFNrbbT8omYtkIJBjbGiApr77/b0OfpYN+8H
         47zf/XN0xHH84A+3UM8hT61G6IS0Hh5S3uF6kNA364rqT3avTS/3cr5Fdv4oD4bIEbJK
         4/t5i7yU4BPusocls/UPBSywXcpnd2DULqqAYpGNtSsWU0j5zwn/yXIGTg3lMXU6ASde
         LfKVhzn8cSyHjNh9h73xxY+rUoEHGoLtLdE72/DrwTxfmCw5IBauJi5VVsvxorMK5UAj
         NGDVko3JNcO2UpqznV9RtxUTIsN9uDuceX+A8em9IgFIGo3R3ry14NPyIw92lCf1sf3b
         F2jw==
X-Gm-Message-State: APjAAAURI3lVUKEdkS+NzlDjCG/6/vyW2VtHwBmdIBE9Oh2g4dpcWvG+
        Owx3EKPQDMotPI/ABGvmOMDJ8w==
X-Google-Smtp-Source: APXvYqx/tYCXEdllU2F4/1JetbgrhH8TFsHxXRye9Amlmvbkp4RD4ve2+88VYqD+upEJsBYYCIqDXw==
X-Received: by 2002:aa7:8554:: with SMTP id y20mr121952964pfn.258.1558808300867;
        Sat, 25 May 2019 11:18:20 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id s24sm6537148pfe.57.2019.05.25.11.18.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 May 2019 11:18:20 -0700 (PDT)
Date:   Sat, 25 May 2019 14:18:18 -0400
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
Message-ID: <20190525181818.GA225569@google.com>
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
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 25, 2019 at 02:14:07PM -0400, Joel Fernandes wrote:
[snip]
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

Come to think of it, if we/I succeed in adding lockdep checking in _raw, then
we can just keep the current APIs and not delete anything. And we can have
_raw_notrace skip the lockdep checks. The sparse check question would still
be an open one though, since _raw doesn't do sparse checks at the moment
unlike _raw_notrace as Steve pointed.

Thanks,

 - Joel

