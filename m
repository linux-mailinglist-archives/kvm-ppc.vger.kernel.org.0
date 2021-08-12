Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6C3EAA3D
	for <lists+kvm-ppc@lfdr.de>; Thu, 12 Aug 2021 20:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhHLS36 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 12 Aug 2021 14:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHLS36 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 12 Aug 2021 14:29:58 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDDAC0613D9
        for <kvm-ppc@vger.kernel.org>; Thu, 12 Aug 2021 11:29:32 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z2so15190290lft.1
        for <kvm-ppc@vger.kernel.org>; Thu, 12 Aug 2021 11:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZPuOYKnJThm5DnalRt4UXLQlArDT4aG/PAjKUg0HeVw=;
        b=GX++fEO8J9HwQl5+UMZcrBWAkh9EvZscWTqeybbmY3/6R4cC9VGrfwpatbe9AHMTW1
         m42nKZyes+ZRqs0i817fF3vvDzp9fD6/hhkcdsGoSS3PfHYT96Pq5BfYgxFQ1GuUQmIC
         k7CbB6iG5hD5/pU6JDv7MUo4HehopFEffLPMy1KeV9eHrc6bTRmb7jJQsemnQ67UNLI4
         0dr4GSUQEybfqghvjC07A5nzS+veTLiIb10v4B0+mhU4aDeX1FsKNetAlZos9xraRsPJ
         iP/I0MPsc2DjTZRvWp+suaZ6y2/naJCEk75lGCKnmPksTxVHj2CnU7vz20s7yYnXenTC
         AUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZPuOYKnJThm5DnalRt4UXLQlArDT4aG/PAjKUg0HeVw=;
        b=bMzCP/qggum1did+LPBIQesPXpt4KL2SYOxuSdqIz0FeWsJ7uBJXuv5v6IFKNaZuvZ
         VHXo92Iro7F980J+TsNKkK6X4MOVb+lIurDnrXTOONpBL8+QDCkTw3fYRwKhqyLpEwMQ
         l3yt/BR8jO8AQjbjNG+fWGBeEyqzzdHnro9iykiqaX1NcOUmDEhJJgjmcOu9X665qWN7
         NKHQrtf86AGOLgMmR2A7b/yf00lXVN6hfRVJUyIgJWmrKCHIpWPqVAFjjg4TyTgZxC/c
         vxz3uPPlxLnIGpP4PAarDLcohYHA0CRTygML0oh1Nhu0lylcsFn7p/ymJ/s8n0gnw/lK
         X67Q==
X-Gm-Message-State: AOAM532kj1kJpzLIpM9+EhyhEnLCi/CR2hwSr80STp2cmAmt5LVVgFGK
        DzUJ4VuUY+k4+b/9ZjwxKENQThY+en4GxEvZ8yaV8g==
X-Google-Smtp-Source: ABdhPJwN5OkbvwtSfxbYBdgMU1en7V1uJ3/kTaDUBt6caukn/Xg6eh44cjYswsOyhQRlGX/oo0jLqfvjMcLHjjdlO1s=
X-Received: by 2002:ac2:46ef:: with SMTP id q15mr3554923lfo.407.1628792970213;
 Thu, 12 Aug 2021 11:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210811233744.1450962-1-jingzhangos@google.com> <6296f7ac-bf99-2198-5a02-9d1ad721cbd3@redhat.com>
In-Reply-To: <6296f7ac-bf99-2198-5a02-9d1ad721cbd3@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 12 Aug 2021 11:29:19 -0700
Message-ID: <CAAdAUtiq5v2TMYVEUYWRqn5Bor64NffiR2bEuu9GEt2hd8PZjA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 12, 2021 at 9:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/08/21 01:37, Jing Zhang wrote:
> > A per VM stat dirty_pages is added to record the number of dirtied pages
> > in the life cycle of a VM.
> > The growth rate of this stat is a good indicator during the process of
> > live migrations. The exact number of dirty pages at the moment doesn't
> > matter. That's why we define dirty_pages as a cumulative counter instead
> > of an instantaneous one.
>
> Why not make it a per-CPU stat?  mark_page_dirty_in_slot can use
> kvm_get_running_vcpu() and skip the logging in the rare case it's NULL.
>
> Paolo
>
Sure, I will make it a per-CPU one in the next version.

Thanks,
Jing
