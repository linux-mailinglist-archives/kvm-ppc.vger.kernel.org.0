Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB57314AD4
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 09:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBIIuy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 03:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhBIIsn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 03:48:43 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DA7C061786
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Feb 2021 00:48:02 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id c132so12030413pga.3
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Feb 2021 00:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=UItTkC1S0isHcanScpoQ+wTmx30vQ0eqqPqpSb2cW14=;
        b=UQWewsmUAO/o+CHnJhrtt2wGtDmSJOPb8TlQJI5b6y0BNDTrj5EAPizNBvBdJx0jLM
         qc0NMgrIxw6aStWs8NLgAEkpp8yN6P7ZRfvYmS6POcXjsJyHLaCDdoxZqhX7gpsxdwh+
         +OHSM9BO/C7+ycPgakZ/cVzZK55jrGgqdhve+7zho43dMlHu225uwnbppTf2x1ZB6V+3
         gmmF69HllvUYRXrZZay593cOyINQuqNoIZDWJbd52u6uT2WzVhhk+WaNRjYg7g6onIM4
         FoPIC+s0ek0ZLlmTyiTn9IP+PqYvsVphca31AozMkOawaFjnKQ1nhFp0PoBY0ro3A1/H
         p4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=UItTkC1S0isHcanScpoQ+wTmx30vQ0eqqPqpSb2cW14=;
        b=XcqNPjKUZEH0hrb/k9TIuXAlTlaY7KZr1tNbBe74nL1ZfmJfVtEkhZ36Xmdv6lafTC
         DtrWYvtmv7vklEs34i0o3isfPZF0Dr8VxTjJl+gzpe9k7fnAOG52+JZIh3w7JMdLo4xu
         YN0JV8vF9lRazUhaineg87DOxqu5Ij29tsOoth7ifJ2GNZ1zk5NSgminy8q1TJnTR3I5
         ZMPh/XmQKQ/YylK6VQOv0DbiP40vzdSm8YxgUNmQP8hF+CNDATPdoGoXa3fTNMY3JGE2
         H1waNZBgjwAG8CZVgmkq5Y5ZpwnYwiw9Tii6M2nZJosyYrXOZOpLZvOhEPjcjHDnWPVN
         V16A==
X-Gm-Message-State: AOAM532gWZwOzCqBKXJ1gUNXZHNTgNWgrnOn1sEy+UKMs8JzS1GJJRkF
        IpqRHNOKuhkV4bB3DpljWt08cgOQXdy2Yw==
X-Google-Smtp-Source: ABdhPJznAZib/PPSdxYOlNOuoMxJOGMnHiXNiqiFQBmRpnun3s42c/x+lKkYzDKm5ZPGUlCMKfg1yA==
X-Received: by 2002:a62:1c86:0:b029:1e0:cacb:8447 with SMTP id c128-20020a621c860000b02901e0cacb8447mr4025588pfc.16.1612860481837;
        Tue, 09 Feb 2021 00:48:01 -0800 (PST)
Received: from localhost (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id w11sm21390715pge.28.2021.02.09.00.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 00:48:01 -0800 (PST)
Date:   Tue, 09 Feb 2021 18:47:55 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a
 vcpu moves between threads in a core
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org
References: <20210118122609.1447366-1-npiggin@gmail.com>
        <20210118122609.1447366-2-npiggin@gmail.com>
        <20210209072355.GB2841126@thinks.paulus.ozlabs.org>
In-Reply-To: <20210209072355.GB2841126@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1612860313.ha7v5sozz4.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of February 9, 2021 5:23 pm:
> On Mon, Jan 18, 2021 at 10:26:09PM +1000, Nicholas Piggin wrote:
>> As explained in the comment, there is no need to flush TLBs on all
>> threads in a core when a vcpu moves between threads in the same core.
>>=20
>> Thread migrations can be a significant proportion of vcpu migrations,
>> so this can help reduce the TLB flushing and IPI traffic.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> I believe we can do this and have the TLB coherency correct as per
>> the architecture, but would appreciate someone else verifying my
>> thinking.
>=20
> So far I have not been able to convince myself that migrating within a
> core is really different from migrating across cores as far as the
> architecture is concerned.  If you're trying to allow for an
> implementation where TLB entries are shared but tlbiel only works
> (effectively and completely) on the local thread, then I don't think
> you can do this.  If a TLB entry is created on T0, then the vcpu moves
> to T1 and does a tlbiel, then the guest task on that vcpu migrates to
> the vcpu that is on T2, it might still see a stale TLB entry.

The difference is that the guest TLBIEL will still execute on the same=20
core, so it should take care of the shared / core-wide translations that=20
were set up. Therefore you just have to worry about the private ones,=20
and in that case you only need to invalidate the threads that it ran on.

Thanks,
Nick
