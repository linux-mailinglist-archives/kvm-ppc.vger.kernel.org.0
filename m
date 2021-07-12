Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716B03C6047
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 18:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhGLQTG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Jul 2021 12:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhGLQTG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Jul 2021 12:19:06 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34E3C0613DD
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Jul 2021 09:16:17 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id h9so9800604ljm.5
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Jul 2021 09:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Lx92m3o1HyXPQthjv0NcXW5cxGIccq8kaKUriYiyX8=;
        b=DuUJKfI40O4hv9E6w78z0AjBGVqYP5wd6acA8v1HwQkjx8eSmjaT9PhmnO6qlURV9X
         J5iVjv+oqU5+pZqEEih9yPNSevbcTVRYzkueRyAO9vtu0em6gbu7UkcBkrIlcuMWuxef
         nPvyd4y0VAOh5HOwD9JvkfSYVD2DDRRdM+RMkc07ct2i93+ZAt5NzK9S1D0zMjDU9PNp
         lzXabQyqhT4kCCYyCrucDe5rOpCXEcomOQcY2lb6W0jfHm2fA4h95BXoynXWlcYuN6jY
         YngwId+fcVp/OsnAUH9bMvSBqBAQGG4Rd883sj276xrJCJ9dnR9Jk7maVYeBwhhy5+Mw
         qOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Lx92m3o1HyXPQthjv0NcXW5cxGIccq8kaKUriYiyX8=;
        b=RGKq63Pmjo9UtO2lc8fsxRARIvi/GpzhNJ4W4It2QJeFwXMvu7v0x/UimKXpAYVx/F
         kRmo3m/6sZs5AeaaiNpoESt2SS8PUJqlRDx/uBOI8JIokOpEG3xvJLNQ4QmIYw+pb7Lq
         ixYXiTQFSzrJ7cqJcJYack9MsCmIQxlUgzCgVMn8w2M2nFZ5r9ivYrLFAVmofP6tY26Y
         2wljwKJXend4owW0r2NXqtoISFDcXLuiPJg7w+iAdwlS5zy+wzJZFp8EFo1ol0KGK1D8
         O6DhZIZmKq4kx21yCg6jOH/sJiNsId9ElNhihIHc4HjZmaUE9CrdgMPi5Py02xxadCZ5
         OluA==
X-Gm-Message-State: AOAM532JPHQzv8eEmUQpyW0JlXY7GgdOgN4ruGB8CB+xMIAMS8rxiqle
        RZy1a0cFu2pA2+gHnrgp1Ee0RfzS8QrZkUerlUosWg==
X-Google-Smtp-Source: ABdhPJw1ttH+evGMQKkgiiJMYtLqWyhKwcc+HdulMt5zTZ65fixW4bLUFKuYH1v1Qqvp3olXJ57gqTcJxah53OZjjtc=
X-Received: by 2002:a05:651c:150a:: with SMTP id e10mr43771401ljf.215.1626106576004;
 Mon, 12 Jul 2021 09:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-2-jingzhangos@google.com> <202107122231.owPJye54-lkp@intel.com>
In-Reply-To: <202107122231.owPJye54-lkp@intel.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 12 Jul 2021 11:16:03 -0500
Message-ID: <CAAdAUth9Dx88+jyCxs-6paSPxf6h42rNEGG1xKowDm4k8h=2Ww@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: stats: Support linear and logarithmic
 histogram statistics
To:     kernel test robot <lkp@intel.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>, kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 12, 2021 at 9:10 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Jing,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on 7caa04b36f204a01dac65582b71d26d190a1e022]
>
> url:    https://github.com/0day-ci/linux/commits/Jing-Zhang/Linear-and-Logarithmic-histogram-statistics/20210707-020549
> base:   7caa04b36f204a01dac65582b71d26d190a1e022
> config: i386-randconfig-a005-20210712 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/aba26c018828dadbff3f53e058c161fab2b09d35
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Jing-Zhang/Linear-and-Logarithmic-histogram-statistics/20210707-020549
>         git checkout aba26c018828dadbff3f53e058c161fab2b09d35
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    ld: arch/x86/../../virt/kvm/binary_stats.o: in function `kvm_stats_linear_hist_update':
> >> binary_stats.c:(.text+0x1ac): undefined reference to `__udivdi3'
Will fix this.
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
Thanks,
Jing
