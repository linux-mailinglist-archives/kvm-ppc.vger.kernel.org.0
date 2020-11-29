Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65632C7AE8
	for <lists+kvm-ppc@lfdr.de>; Sun, 29 Nov 2020 20:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgK2TR7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 29 Nov 2020 14:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2TR6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 29 Nov 2020 14:17:58 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0A8C0613CF
        for <kvm-ppc@vger.kernel.org>; Sun, 29 Nov 2020 11:17:18 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id s13so1223140ejr.1
        for <kvm-ppc@vger.kernel.org>; Sun, 29 Nov 2020 11:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=j9dGwZfBcb0Riat7yy8R7Lta6DvXUqCXqciluQp9tjo=;
        b=HfR2Vy8vKl8ZUDYwX3h/g6lwyDQkQoWfudng/b4pVWGgmSpA/M4210L+SfsRK0kyAH
         dn3LomC0K1RwD/4zyqzmSnKdtRW2mgATNdB3Z+25NrOKV/pvdOF+GC/UIRcyoiPdS2tr
         t/3tINvR3C62nneUoD+kJIwMOFSzfxDnIibpt01vnOj+N97/VTQNL0xSgjWwUS7QKNdJ
         l2AboZ7OMqQPDaMJRugrVq2uCYtFWBO5W7QlMfuIs0jaYy4PDOlW8m2AMaGYM8EZQhSE
         YhhZnfmOKCKWLEJGe6HdvuxVTK5pQrb/1BTTHHZqdbCGzT2xt54HkOjx0RmitBKpnUCL
         l0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=j9dGwZfBcb0Riat7yy8R7Lta6DvXUqCXqciluQp9tjo=;
        b=XVs2eVHh7xVx2ZweUN1rhQ4GbkM8zKnqGuLO8aSvsXcIyI6jg7YzPEitvjUKdrvJ6S
         jhgGLKxpKprkcAp2RoeRgXanTDLdGWPhFCL8MJ465mKEhpTZr+qsRxPp3sxt3/PSWB6q
         2v7lv6VoVhZ8Vu+5RB8kcU1EV8okJGkGBzxMSeIuY8oUIFxAR2DvamhG8s3JLDJr8CLU
         owt+9Ws3937qofTZH7yYsYwIqjPb+h+TXhHd5h9O1PIeCLkfKUHIxSVlvEgRjIhppuaQ
         Lanqk30yV0o6okHRagdJgs2Ud1QgOnYJDY/OmpG8lI2dHgo63UHZsK50UJrWEc2Xe8Ba
         Dlfg==
X-Gm-Message-State: AOAM531cSwDbZeRRKQCj0vKeBqTxynaIOACuXa6JRzNfy2rtK+kUM65n
        YqRZc9N7pYcJBeq3FePjKnfb9T27n5WHtUWFTvaNBAo=
X-Google-Smtp-Source: ABdhPJxXzDVHUjp6MHxfOI2JsovxpjeysKuLZtIjU6ntj22ZiC0uvQG+O5H/1qt2NeaNz+0RNq8r1VzYSrAjvyl9diM=
X-Received: by 2002:a17:906:a195:: with SMTP id s21mr17654959ejy.146.1606677436397;
 Sun, 29 Nov 2020 11:17:16 -0800 (PST)
MIME-Version: 1.0
From:   Jim <jdonoghue04@gmail.com>
Date:   Sun, 29 Nov 2020 14:17:05 -0500
Message-ID: <CALe-uE834fs-Ek4uFszT0njGXxAGCBqEcXMUzZft5LD-Jw7Tbw@mail.gmail.com>
Subject: hcall H_READ when running kvm-hv: where serviced?
To:     kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I'm trying to find the correct handler for H_READ. The two functions I
have patched don't ever seem to be called: kvm_htab_read() in
book3s_64_mmu_hv.c and kvmppc_h_read() in book3s_hv_rm_mmu.c
It appears the call is intercepted somewhere else. Could someone
enlighten me on where else I should be looking?
