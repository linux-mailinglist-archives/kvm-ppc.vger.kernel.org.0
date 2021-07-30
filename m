Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF973DBDCC
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Jul 2021 19:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhG3ReS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Jul 2021 13:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhG3ReS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 30 Jul 2021 13:34:18 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256D0C061765
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Jul 2021 10:34:13 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l4so13436253ljq.4
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Jul 2021 10:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mlX1nCiNDRiVrVxlVDHszrB0v/ewjTsjg4ostQyNPUg=;
        b=bynegcZxgDCEpUi8d2HuAzcpZ1tEmeaASJMHmkOYZc3mvMjCLUDIbTm+O1VuoWz91H
         9R28kLzaqtrtHbh9yTEfJSESk7sV+cF8+oLbjR9RXqSJqaX0bVci5a3SnRsowoV+yED6
         qZ1TK7yxLK6D7Dwz70IPalyohCTfsZ0VxZdPgPixwDQdgqQw/m4dO7i2KIOJ2e+w+ygF
         e9QCCHbYO5VNcNwQ9EfUkoqJQg+ZrK8WL7ZrKiM7muXUNXPn/a3WuhkqK+lk8Fc+TMQZ
         ia21dWwC18DDnXBaP3W4XQnWopcwzowFvE3wYZ8lhNd61SbFTMvyTL7EpbyJclo+l3xb
         +6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mlX1nCiNDRiVrVxlVDHszrB0v/ewjTsjg4ostQyNPUg=;
        b=cKlKNp/U6F3zZgowcQPMnPlYGixPalh6kfTHpl6jPh/dPjaTHvFxwxZjmCxsFVcxHl
         2isbdfkK3lmZLlN9T0i3++jPwx0PuJ87+8hQX8sVPB8NpQemkDgavHYf7eO8yCipN51z
         Bmy83iqJsFFr36nDACdzGoXwWXe/nmYWWDH/koqcr3TZNxMe38dUI8cVJ1ej8rygaVx6
         RBvSAMVvDUlcoFPXWVxF9VFpnSyW0ZWPlTRM8pSi2og2ZYRJqiyfeW+aABmzr3C5ijqZ
         7KFQwSSzuCTa8a1Wi9Q1BnsLfKCXj61FPJk3HCLQHz99dL2Z3WujYz5bWrkMw32yDq0k
         +5kA==
X-Gm-Message-State: AOAM530boRK3Nh55ReJAzPng2+Ap+Uk0ktumehCE/XYbXOOSJh0hKMeH
        Qg66CX5JL6kggaLDG6CsZdKf/GkmmC6tLNOIuJJrGA==
X-Google-Smtp-Source: ABdhPJwQm7osgysjal7b4gFKQif1+BNO+0WNNDORDMRHHkvDuxmU8Mm408VnxrPPcR+CR90UPsnKxeheV7HfFlQNNJA=
X-Received: by 2002:a2e:90c4:: with SMTP id o4mr2361162ljg.28.1627666451240;
 Fri, 30 Jul 2021 10:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-5-jingzhangos@google.com> <8a6f9314-7329-54d1-63b4-dc7ba6b4ea1d@redhat.com>
In-Reply-To: <8a6f9314-7329-54d1-63b4-dc7ba6b4ea1d@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 30 Jul 2021 10:34:00 -0700
Message-ID: <CAAdAUtg6TNQ=_UrMe_mZ8Hv_u98i7gMybMUPKsnCXZkjivDRiQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] KVM: stats: Add halt polling related histogram stats
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jul 28, 2021 at 5:45 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/07/21 20:03, Jing Zhang wrote:
> > +             kvm_stats_log_hist_update(
> > +                             vc->runner->stat.generic.halt_wait_hist,
> > +                             LOGHIST_SIZE_LARGE,
> > +                             ktime_to_ns(cur) - ktime_to_ns(start_wait));
>
> Instead of passing the size to the function, perhaps you can wrap it
> with a macro
>
> #define KVM_STATS_LOG_HIST_UPDATE(array, value) \
>      kvm_stats_log_hist_update(array, ARRAY_SIZE(array), value)
That's nice! Will do that.
>
> Paolo
>
Thanks,
Jing
