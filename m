Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6C3437C9
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 05:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVEGx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 00:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCVEGX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 00:06:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8CFC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 21:06:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so9744709pjc.2
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 21:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=MgSbLNOjzWTK+0uwZ7SzymSxTsdNF7f6+E7B6gVkrKw=;
        b=CMuTQNMBjDdzZq3E/C4fKIQ1FL3HDQTbcx6uFdPs25M6zPucIcArgN1lq33B/dcBjO
         MrZ5X7RLSa/VUfh2PhJ8yD8KZPpE2adivWcjqaN4QugKLiBq+CkJGh3KeB9audmasXbO
         ysQ9Hc3itPhikB/FAA7Po90KKKpxadTRVc/9x5CXf+8Ravi1Zo8KS2gawU65S+KhcBkx
         u5u3UMMymNQ1gNCz6vCAv14JmwdmzexXmLAwebBkNkF5ztJvLXn7Q/1OCj5f14uCvw1p
         RgUST1CF7BgNS7yIK/5WuIGN9GZjrQSuQZYgvRL7uWwRbZ4DUyczLCbZ12QkRQ//V/p5
         JqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=MgSbLNOjzWTK+0uwZ7SzymSxTsdNF7f6+E7B6gVkrKw=;
        b=ALFiG9FYbDWFvGkbrASXHnEs+XmXUnSUYb8IhDmqC5Fp1nEWczO04gisegJ/56GiSx
         qFfgq2EsHNE2jt06uzBKMFb68soQL+l38dJDZ7xWv3DP2AM1zxHfqcSARDyvxt+LM2mu
         1HWtA4/S2dS0GJrCQhbISKOdFQBOqooOKlhb+4ZKchzojEQ8kFZMEI2SA3bDtSY6AwrX
         9CrrMvmwB8HVgimuhom6ZCgPJSsKx9JSDsTm1H7iG2ab3voMir031UwT1777OqTicV3b
         DUrcxycsoyhySuK5ygJATH9byCNBlspG4RvdPfzkFaG4kvVjnvUDoaLqvEnlRASBeDHH
         OqMw==
X-Gm-Message-State: AOAM533iE29CamBGLIcHQZ7yWb3CGBxmPnven3lrdmfkF/iAvZZ+Bpkq
        ZjKxF1F+mFLEhgNMPa08JFKRPTWKLUE=
X-Google-Smtp-Source: ABdhPJyd4INNrI9YdT3vXBq+7ZOGEmGLoNYV+8CvpsMVx97Rklb8MehDcUmn9iEp7JJJEl7rRqdbsA==
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr11000599pjp.166.1616385982755;
        Sun, 21 Mar 2021 21:06:22 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id t6sm11971114pjs.26.2021.03.21.21.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 21:06:22 -0700 (PDT)
Date:   Mon, 22 Mar 2021 14:06:16 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 15/41] KVM: PPC: Book3S 64: Minimise hcall handler
 calling convention differences
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-16-npiggin@gmail.com>
In-Reply-To: <20210305150638.2675513-16-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1616385477.zdncmgsbmf.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of March 6, 2021 1:06 am:
> This sets up the same calling convention from interrupt entry to
> KVM interrupt handler for system calls as exists for other interrupt
> types.
>=20
> This is a better API, it uses a save area rather than SPR, and it has
> more registers free to use. Using a single common API helps maintain
> it, and it becomes easier to use in C in a later patch.

On second look I'm happy enough with this.

It does add some hcall setup code back into exception-64s.S and removes
most of the "fixup" code that was previously moved into=20
book3s_64_entry.S in patch 12. But if you take patch 12 and 13 and other
earlier patches together they are moving most KVM interrupt knowledge
into KVM which is a good change.

Once that is done, this final one then gets hcall into better shape for
the C code. If anything this patch could go together with patch 12 but
I guess I ended up writing it for the C code whereas the previous ones
were cleanups so the ordering didn't come out that way. It won't be
trivial to move now so I don't think I'd bother.

Thanks,
Nick
