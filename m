Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A551372592
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 May 2021 07:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhEDFpB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 May 2021 01:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDFpB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 4 May 2021 01:45:01 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B773C061574
        for <kvm-ppc@vger.kernel.org>; Mon,  3 May 2021 22:44:06 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b17so5443138ilh.6
        for <kvm-ppc@vger.kernel.org>; Mon, 03 May 2021 22:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G9ESRXefOvFcFU8JizCeiw+vMSlHN+RPYh9AjhBOqb8=;
        b=G5DClEfzuTVYVNRsJKfQJ2Q1QTCN37SlLVFqqvhciqDzHPQ8XnFr/N9dHmw9TTfN0E
         VggOshctvx5Zzn4ijwk+NXVBCytTblKaq5629URM4CAT21Wbb2K9q3OQm/ndSud7R3pE
         8cgnqNtHpaIC1YNScouwr2wZWkYcGdwQZSsGoF6WGwomhGjRvhMdi/9TicMzEkGUDxc6
         zJ8OI1WwyGfzkvfPkukevttNOdxFfQwLEtQXFuzGhjhm5GOeN4+Hy6JHPr6Y4VolxemC
         tHlCiWuXhyS3cTMq8rUTYfA5+F1p+otPe2Ke3gKn0kOznsDMJABwwOg5LUijFQ8jZu7y
         Lsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G9ESRXefOvFcFU8JizCeiw+vMSlHN+RPYh9AjhBOqb8=;
        b=q+Cr8YvcDRIPxLXXxlJtD6jTexGXHbeTwQ/UaGDNm8LEWvgBX2GXwcOicQ7Mt1Dvzk
         fLAzChYQ+lCfaZzoUTJQA83i97qAmPfSdwKxiJY0dZqk0Xb2BDbBC0baTSZNLZO/u97z
         gR76u5sEqWqWJuUZ3k7lXnL+jL2NI7K3tiA/Dqe4qLZoOqIIhcXkX276sLg2QU22QeD1
         5PCxvYgn819KRfITpVktYNKyZB5o+cgpL3SrLqwFxgV5/sAb2CxRmUeAjXgh/4tfoLkl
         IZfuFn/6+17Qv/SBFTM13Z9s+40rz4v3Gh6a9ayXObGEgye1kGMnVqQTomKqBL+93zjh
         yNiA==
X-Gm-Message-State: AOAM531Zu6g4OmJp9lHDCMPniT1fr3CPS8QczReloQqckI1R9NeTN5VR
        kVjlLV+w8r4WiqcVpF0GLv8A+3S2T2zmdpM3TVM=
X-Google-Smtp-Source: ABdhPJzC6alOzJqNjv57N04F4U3tHUEdbtp1zl/QgLQrapXHd+EvE5w35e9Iti1fnaIY0tTwULyBboMTw8lYepmsnxs=
X-Received: by 2002:a05:6e02:160d:: with SMTP id t13mr19821606ilu.85.1620107045748;
 Mon, 03 May 2021 22:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
 <CAPcyv4gwkyDBG7EZOth-kcZR8Fb+RgGXY=Y9vbuHXAz3PAnLVw@mail.gmail.com>
 <bca3512d-5437-e8e6-68ae-0c9b887115f9@linux.ibm.com> <CAPcyv4hAOC89JOXr-ZCps=n8gEKD5W0jmGU1Enfo8ECVMf3veQ@mail.gmail.com>
 <d21fcac6-6a54-35fd-3088-6c56b85fbf25@linux.ibm.com>
In-Reply-To: <d21fcac6-6a54-35fd-3088-6c56b85fbf25@linux.ibm.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 4 May 2021 07:43:53 +0200
Message-ID: <CAM9Jb+g8bKF0Z7za4sZpc2tZ01Sp4c4FEaV65He8w1+QOL3_yw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] nvdimm: Enable sync-dax property for nvdimm
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eric Blake <eblake@redhat.com>, qemu-arm@nongnu.org,
        richard.henderson@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>,
        shameerali.kolothum.thodi@huawei.com, kwangwoo.lee@sk.com,
        Markus Armbruster <armbru@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        kvm-ppc@vger.kernel.org, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> > The proposal that "sync-dax=unsafe" for non-PPC architectures, is a
> > fundamental misrepresentation of how this is supposed to work. Rather
> > than make "sync-dax" a first class citizen of the device-description
> > interface I'm proposing that you make this a separate device-type.
> > This also solves the problem that "sync-dax" with an implicit
> > architecture backend assumption is not precise, but a new "non-nvdimm"
> > device type would make it explicit what the host is advertising to the
> > guest.
> >
>
> Currently, users can use a virtualized nvdimm support in Qemu to share
> host page cache to the guest via the below command
>
> -object memory-backend-file,id=memnvdimm1,mem-path=file_name_in_host_fs
> -device nvdimm,memdev=memnvdimm1
>
> Such usage can results in wrong application behavior because there is no
> hint to the application/guest OS that a cpu cache flush is not
> sufficient to ensure persistence.
>
> I understand that virio-pmem is suggested as an alternative for that.
> But why not fix virtualized nvdimm if platforms can express the details.
>
> ie, can ACPI indicate to the guest OS that the device need a flush
> mechanism to ensure persistence in the above case?
>
> What this patch series did was to express that property via a device
> tree node and guest driver enables a hypercall based flush mechanism to
> ensure persistence.

Would VIRTIO (entirely asynchronous, no trap at host side) based
mechanism is better
than hyper-call based? Registering memory can be done any way. We
implemented virtio-pmem
flush mechanisms with below considerations:

- Proper semantic for guest flush requests.
- Efficient mechanism for performance pov.

I am just asking myself if we have platform agnostic mechanism already
there, maybe
we can extend it to suit our needs? Maybe I am missing some points here.

> >> On PPC, the default is "sync-dax=writeback" - so the ND_REGION_ASYNC
> >>
> >> is set for the region and the guest makes hcalls to issue fsync on the host.
> >>
> >>
> >> Are you suggesting me to keep it "unsafe" as default for all architectures
> >>
> >> including PPC and a user can set it to "writeback" if desired.
> >
> > No, I am suggesting that "sync-dax" is insufficient to convey this
> > property. This behavior warrants its own device type, not an ambiguous
> > property of the memory-backend-file with implicit architecture
> > assumptions attached.
> >
>
> Why is it insufficient?  Is it because other architectures don't have an
> ability express this detail to guest OS? Isn't that an arch limitations?
