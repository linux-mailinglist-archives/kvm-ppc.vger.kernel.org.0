Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7862EFE
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 05:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfGIDfr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Jul 2019 23:35:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37376 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIDfq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Jul 2019 23:35:46 -0400
Received: by mail-io1-f66.google.com with SMTP id q22so18286041iog.4
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Jul 2019 20:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JaoS/xwrcMjIyr9vgUEMUpK0WXNWdCfn6nTIH2BE7qQ=;
        b=CJiBwLV5d+8M2nDN0l29OD9oOwFkZvQoIR4HUnv0UQ4NohKFOo1RKAcFeHlwOYMO9i
         f6jwhMx3F1p5VQOg0l1HpNW5pOO7dcJ95KmvIfsWjS12lEJmmeaV4T6XbSLmUzunL7Z4
         +zW6MwPB7bI6z6pSHSxdr0dEEsvafIfdE572BvarSbTMr+XUWVUTehcJG0/L1fcQ/Ci8
         olUrOBTiavU0DFXo41r7uzix7DUCrJbRzks//xpgHwAqMzeOJfoZ84MZH+HZfFd1nb6i
         gW/yDvsfm4d0/VKYH2AHJBhgTI9H8xG4tWym6ofLZUfHXD8+K2ifPy+8LRyVrq/DKF56
         QHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JaoS/xwrcMjIyr9vgUEMUpK0WXNWdCfn6nTIH2BE7qQ=;
        b=njsg3+d8ppVpJTt55XxNhV9yzU+2CDGcMjnyiKDfK/1lCelJS4laOWAitxN3I9sO/J
         zwUAWCL9rqOJVHoUdUHea4prvXbl93SE0w/JadLUydJqMz40fxlfkV690N+sR8349/Ju
         t6IZslnIC2FcB2mK3MiCN4SwIk1O8D+HoEEWEQLa3cBJ1Rz4u3N4/5bDeOiD11aY4n9O
         3rFI+vqismuXcagoLWUBnvEhZGuDR+u66GYkrL26gSa0vGlDBLVL32e/fUY0opji/FP8
         D0lh+wEqDyecvjurFUjhsZBYbsz+B08tYW4F/buYj5e8Z9IlrRJHp7OKo8NQt2h22MrA
         VA+A==
X-Gm-Message-State: APjAAAWW77L86N+rqCoC7n71I2ZDnNuxThXw0MLYgcRoY6MjsLxbCFQY
        m1BKbq0vMf7brZK9LnUUYpGVw//IdMCWEmqXGPo=
X-Google-Smtp-Source: APXvYqw7JnmTFV0p9XmcusnvRmMRsnItsAf/xkVOhqmIsHhlm0im+EMiWG47Gg3GvkqR0idBrlfL2NC7mAiMrglhHsE=
X-Received: by 2002:a5d:8404:: with SMTP id i4mr8929682ion.146.1562643345658;
 Mon, 08 Jul 2019 20:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190708201249.29649-1-cclaudio@linux.ibm.com>
In-Reply-To: <20190708201249.29649-1-cclaudio@linux.ibm.com>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Tue, 9 Jul 2019 13:35:34 +1000
Message-ID: <CAOSf1CHmvvKHn4oHD28HcUHPh579ZjxQc50kBEMtrn60QiX1BA@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc/powernv: Add ultravisor message log interface
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev <linuxppc-dev@ozlabs.org>, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>, Joel Stanley <joel@jms.id.au>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jul 9, 2019 at 6:12 AM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>
> From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>
> Ultravisor provides an in-memory circular buffer containing a message
> log populated with various runtime message produced by firmware.
>
> Based on "powernv/opal-msglog.c", this patch provides a sysfs interface
> /sys/firmware/opal/uv_msglog for userspace to view the messages.

No, it's a copy and paste of the existing memcons code with "uv"
sprinked around the place. I don't mind stuff being c+p since it's
occasionally justified, but be honest about it.

> diff --git a/arch/powerpc/platforms/powernv/opal-uv-msglog.c b/arch/powerpc/platforms/powernv/opal-uv-msglog.c
> new file mode 100644
> index 000000000000..87d665d7e6ad
> --- /dev/null
> +++ b/arch/powerpc/platforms/powernv/opal-uv-msglog.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * PowerNV OPAL in-memory ultravisor console interface
> + *
> + * Copyright 2018 IBM Corp.
> + */
> +#include <asm/io.h>
> +#include <asm/opal.h>
> +#include <linux/debugfs.h>
> +#include <linux/of.h>
> +#include <linux/types.h>
> +#include <asm/barrier.h>
> +
> +/* OPAL in-memory console. Defined in OPAL source at core/console.c */
> +struct memcons {
> +       __be64 magic;
> +#define MEMCONS_MAGIC  0x6630696567726173L
> +       __be64 obuf_phys;
> +       __be64 ibuf_phys;
> +       __be32 obuf_size;
> +       __be32 ibuf_size;
> +       __be32 out_pos;
> +#define MEMCONS_OUT_POS_WRAP   0x80000000u
> +#define MEMCONS_OUT_POS_MASK   0x00ffffffu
> +       __be32 in_prod;
> +       __be32 in_cons;
> +};
> +
> +static struct memcons *opal_uv_memcons;
> +
> +ssize_t opal_uv_msglog_copy(char *to, loff_t pos, size_t count)
> +{
> +       const char *conbuf;
> +       ssize_t ret;
> +       size_t first_read = 0;
> +       uint32_t out_pos, avail;
> +
> +       if (!opal_uv_memcons)
> +               return -ENODEV;
> +
> +       out_pos = be32_to_cpu(READ_ONCE(opal_uv_memcons->out_pos));
> +
> +       /*
> +        * Now we've read out_pos, put a barrier in before reading the new data
> +        * it points to in conbuf.
> +        */
> +       smp_rmb();
> +
> +       conbuf = phys_to_virt(be64_to_cpu(opal_uv_memcons->obuf_phys));
> +
> +       /*
> +        * When the buffer has wrapped, read from the out_pos marker to the end
> +        * of the buffer, and then read the remaining data as in the un-wrapped
> +        * case.
> +        */
> +       if (out_pos & MEMCONS_OUT_POS_WRAP) {
> +
> +               out_pos &= MEMCONS_OUT_POS_MASK;
> +               avail = be32_to_cpu(opal_uv_memcons->obuf_size) - out_pos;
> +
> +               ret = memory_read_from_buffer(to, count, &pos,
> +                               conbuf + out_pos, avail);
> +
> +               if (ret < 0)
> +                       goto out;
> +
> +               first_read = ret;
> +               to += first_read;
> +               count -= first_read;
> +               pos -= avail;
> +
> +               if (count <= 0)
> +                       goto out;
> +       }
> +
> +       /* Sanity check. The firmware should not do this to us. */
> +       if (out_pos > be32_to_cpu(opal_uv_memcons->obuf_size)) {
> +               pr_err("OPAL: memory console corruption. Aborting read.\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = memory_read_from_buffer(to, count, &pos, conbuf, out_pos);
> +
> +       if (ret < 0)
> +               goto out;
> +
> +       ret += first_read;
> +out:
> +       return ret;
> +}
Make this take an struct memcons as an argument and use the same
function for the opal and UV consoles. Two copies of the same code
with tricky barrier crap in them is not a good idea.

> +static struct bin_attribute opal_uv_msglog_attr = {
> +       .attr = {.name = "uv_msglog", .mode = 0444},
We made the OPAL console only readable to root recently, so the mode
should be 0400.
> +       .read = opal_uv_msglog_read
> +};
> +

> +void __init opal_uv_msglog_init(void)
> +{
> +       u64 mcaddr;
> +       struct memcons *mc;
Declarations are reverse-christmas-tree, so these should be the other
way around.

> +
> +       if (of_property_read_u64(opal_node, "ibm,opal-uv-memcons", &mcaddr)) {
> +               pr_warn("OPAL: Property ibm,opal-uv-memcons not found\n");
> +               return;
> +       }
> +
> +       mc = phys_to_virt(mcaddr);
> +       if (!mc) {
> +               pr_warn("OPAL: uv memory console address is invalid\n");
> +               return;
> +       }
> +
> +       if (be64_to_cpu(mc->magic) != MEMCONS_MAGIC) {
> +               pr_warn("OPAL: uv memory console version is invalid\n");
> +               return;
> +       }
> +
> +       /* Report maximum size */
> +       opal_uv_msglog_attr.size =  be32_to_cpu(mc->ibuf_size) +
> +               be32_to_cpu(mc->obuf_size);
> +
> +       opal_uv_memcons = mc;
> +}

You can probably share this too if you make it take the DT property
name of the memcons address as an argument, e.g:

struct memcons *opal_uv_msglog_init(const char *dt_prop_name)

> +
> +void __init opal_uv_msglog_sysfs_init(void)
> +{
> +       if (!opal_uv_memcons) {
> +               pr_warn("OPAL: message log initialisation failed, not creating sysfs entry\n");
> +               return;
> +       }
> +
> +       if (sysfs_create_bin_file(opal_kobj, &opal_uv_msglog_attr) != 0)
> +               pr_warn("OPAL: sysfs file creation failed\n");
> +}

> diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
> index 89b6ddc3ed38..ed000a788456 100644
> --- a/arch/powerpc/platforms/powernv/opal.c
> +++ b/arch/powerpc/platforms/powernv/opal.c
> @@ -946,6 +946,7 @@ static int __init opal_init(void)
>
>         /* Initialise OPAL message log interface */
>         opal_msglog_init();
> +       opal_uv_msglog_init();

Gate this behind a FW_FEATURE_ULTRAVISOR (or whatever it is) check.
The opal_uv_msglog_init() prints errors at pr_warn() which is going to
be spurious for non-uv systems.

>         /* Create "opal" kobject under /sys/firmware */
>         rc = opal_sysfs_init();
> @@ -964,6 +965,7 @@ static int __init opal_init(void)
>                 opal_sys_param_init();
>                 /* Setup message log sysfs interface. */
>                 opal_msglog_sysfs_init();
> +               opal_uv_msglog_sysfs_init();
Also gate this.

Basicly, fold this all into the existing memcons code and ifdef the UV
specific bits. They're just not different enough to justify doing
otherwise.

Oliver
