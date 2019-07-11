Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130AF660E7
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jul 2019 22:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfGKUuk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 16:50:40 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43236 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGKUuk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jul 2019 16:50:40 -0400
Received: by mail-lj1-f194.google.com with SMTP id 16so7151153ljv.10
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Jul 2019 13:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dYjxp66wgB3t394QorK0WPrW2jXGX2qG/znE9bxRn1o=;
        b=OH1nH1JxcyIJ1Frv7bR1psVD2AkOX68Z06jMu6w+iKf4koMKEnVt0JThRnXKzImvV7
         J3Z3Nl/H5FA/erTmCGF/qw3sMCLW0JXQR/CgOLxF+xN3iTuTAPf+3vmVJxb5wDaonHmn
         N5opQfDUhQroiwNBX3un98PdvECR62kpygl3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dYjxp66wgB3t394QorK0WPrW2jXGX2qG/znE9bxRn1o=;
        b=oA/DlPDXJRavEQ3HOHuDRE1upo8sHduECL1WNKWoUI+5m3mHRxIqws64KddnWIIJmC
         YS9ZRyq5TiVZ+tYdmiTWtG+oOol2sL3SM8c75cBp7QgntDvbM1mCJlE9xapuL9d7mhfJ
         eQO805vBrNoHXgLruAzhkoOt4D/ZkrQDcngoqx++TjhVtd1P4+0/t1d6qQY639UBxPv2
         DSFD8JGEj89s5xjdC94qbspu18Ry3h65SpFGjEkexhMl/outXN+Bmx7OZEBrIOd2wJuH
         bpSSEXGQs7LYnOY4l9ugWVvzFr+fpan3c6nM9i2ZfBHUCEju0WNuaLNwGtCc0kIO2fBO
         P7FA==
X-Gm-Message-State: APjAAAVvIDdevUrkW9gWq/ME9ZnPzVA/ltQkI6c9a1uk1n8mQCAcEttY
        rIg0yEtWLVuB02tTQlMTnUzRoEizqyKDt2esHZ4=
X-Google-Smtp-Source: APXvYqyTowl8LDpO3glgWe4q53UddCDACSqIkn83mbNwYk66wIQHKoZZ8RculjXa8Wt7mSwwCQxgYNfcJFE9RnOFrVI=
X-Received: by 2002:a2e:9147:: with SMTP id q7mr3641900ljg.19.1562878238030;
 Thu, 11 Jul 2019 13:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190711204541.28940-1-joel@joelfernandes.org>
In-Reply-To: <20190711204541.28940-1-joel@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 11 Jul 2019 16:50:26 -0400
Message-ID: <CAEXW_YS=Sb6k4_Z-fXdtERTHZDO_PHQCOhx6bhotWduCB7K28w@mail.gmail.com>
Subject: Re: [PATCH] treewide: Rename rcu_dereference_raw_notrace to _check
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu <rcu@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Byungchul Park <byungchul.park@lge.com>,
        kernel-team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 11, 2019 at 4:45 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> The rcu_dereference_raw_notrace() API name is confusing.
> It is equivalent to rcu_dereference_raw() except that it also does
> sparse pointer checking.
>
> There are only a few users of rcu_dereference_raw_notrace(). This
> patches renames all of them to be rcu_dereference_raw_check with the
> "check" indicating sparse checking.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

There also these _notrace things but I am Ok with leaving them alone for now:
hash_for_each_possible_rcu_notrace
hlist_for_each_entry_rcu_notrace

- Joel
