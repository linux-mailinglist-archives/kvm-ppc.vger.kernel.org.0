Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9609216EB19
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Feb 2020 17:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgBYQQ4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Feb 2020 11:16:56 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37893 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQQ4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Feb 2020 11:16:56 -0500
Received: by mail-ot1-f66.google.com with SMTP id z9so38676oth.5
        for <kvm-ppc@vger.kernel.org>; Tue, 25 Feb 2020 08:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hlv8glY/nETgRGQM3JrX7U+aqQLACOo8EtOJKWLyg2o=;
        b=pvmjF/YK/Llxj+KwQTKvFsDg33CBSxEkGh+RZmGNIHEKerUVTdAvcuUFYvXqpYL9+r
         lTArS0BYMJ/EA5azo0fl3vcMyZcK+zSUb7g+j1ySKdseWpQlcvmWlz8CF3iueT4dgByv
         807h3wLRfTDkU81vYKTM06rHLWXODWUPSfjOUmFuhu541V6ArRppRXhXBOXfUrvUCnPq
         Mpt8rUP4A3TJnwG7gAqUvU7ctZexojhvKWMY66MgVU0qMeIYIlKxrC9qeaj3b0aAbwEv
         f+Zj+t0k03vMYQz8Gr8tuY3cXljzjhe1UqtEO6T74nigH8FDdpJT7UfibHPu/3YIEfcX
         gQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hlv8glY/nETgRGQM3JrX7U+aqQLACOo8EtOJKWLyg2o=;
        b=troRWalIi21QL2kxTxef/R6uZzS+jzJ2bAuluDRxhCnS6F608bBhr6Ro5SL3tfhrOK
         5aFubav2yEZIkbGC29APGPaDlm06/xEjbMxnoxlPWg9CwjneIJsYsPwJsfq2pvoNkr+e
         3XhOzju44zIlKkwZDAEUsA+T+wJTPaKk7bR5Sj874pyrRfaC3kfaobMpUOS/oczGabKs
         pgRESD9h7I1+h+cneK6UdzhFQ32wEQCFOfCIELYpeX2TY7KmLTFgWRlL6E7d/KOJ9f7v
         HOf+9b6W1dQR4RzqYaOdh1RniJ136Bue9iUC+qvr/PCu8K8gF67g2jZm1MX+pgEMlMjz
         F/lw==
X-Gm-Message-State: APjAAAUJaXMxktxhscNHXMFUP1kxsqbeUJq1eTMpLk03N3DQ3WPqs2qX
        BfnHKdsad7h/MKWNvophC6rBVL6S5yojPwlvIHmsWQ==
X-Google-Smtp-Source: APXvYqwrQZAseC96mjkcu4WFviym/5+i8KWdLsn7ZJyRU6pF2+Hzhyqk2VMhlES5mY819yutsnfzMFQTlFmo0u79KhE=
X-Received: by 2002:a05:6830:13da:: with SMTP id e26mr42364907otq.97.1582647415115;
 Tue, 25 Feb 2020 08:16:55 -0800 (PST)
MIME-Version: 1.0
References: <CAM2K0nreUP-zW2pJaH7tWSHHQn7WWeUDoeH_HM99wysgOHANXw@mail.gmail.com>
In-Reply-To: <CAM2K0nreUP-zW2pJaH7tWSHHQn7WWeUDoeH_HM99wysgOHANXw@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 25 Feb 2020 16:16:43 +0000
Message-ID: <CAFEAcA84xCMzUNfYNBNR8ShA58aor_rbYTq7jnmsLQqhvbOH8w@mail.gmail.com>
Subject: Re: Problem with virtual to physical memory translation when KVM is enabled.
To:     Wayne Li <waynli329@gmail.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, kvm-ppc <kvm-ppc@vger.kernel.org>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 25 Feb 2020 at 16:10, Wayne Li <waynli329@gmail.com> wrote:
> So what could be causing this problem?  I=E2=80=99m guessing it has somet=
hing
> to do with the translation lookaside buffers (TLBs)?  But the
> translation between virtual and physical memory clearly works when KVM
> isn=E2=80=99t enabled.  So what could cause this to stop working when KVM=
 is
> enabled?

When you're not using KVM, virtual-to-physical lookups are
done using QEMU's emulation code that emulates the MMU.
When you are using KVM, virtual-to-physical lookups
are done entirely using the host CPU (except for corner
cases like when we come out of the kernel and the user
does things with the gdb debug stub). So all the page
tables and other guest setup of the MMU had better match
what the host CPU expects. (I don't know how big the
differences between e5500 and e6500 MMU are or whether
the PPC architecture/KVM supports emulating the one on
the other: some PPC expert will probably be able to tell you.)

thanks
-- PMM
