Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD94C511
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Jun 2019 03:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfFTBpW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Jun 2019 21:45:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43645 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfFTBpW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Jun 2019 21:45:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so648908pgv.10
        for <kvm-ppc@vger.kernel.org>; Wed, 19 Jun 2019 18:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3rH4Li7iQpV2NhLM6R10n6Rmb0Kzzsbup8BQ7TSxMNU=;
        b=iwtIMmeIJr/cVxE3WxYjZrIBVtItI9+cJkvTm/V2qUz+gSDLgMDlsFlakN/liAj6UP
         vTnVse3C+Zb6iPCkWTFoUZ/vRV7GfEd8BBSZQnyekicM0Bo0Iepkg6Cb9bdZjXDYlMcS
         K2U0CNMUdr+8X1DG2Zw2z1Y568j7zu4EgtRmW/zH3k3KORFFMDPL3a1Cp6/8yppUkC7S
         J3rc6HgY6mhVZa3t8SFDIVXsqDiUQ7cvClS0d43HDUt5L28IHFmqBedo/3qLZkDzoOSl
         JGbm6mvKONrTtgqxwLC1WCMFjYQEnjrIL9XyfAgA9mXCeKD3/DWczpPrJFCPh0+g42i/
         CkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3rH4Li7iQpV2NhLM6R10n6Rmb0Kzzsbup8BQ7TSxMNU=;
        b=SX0iFiLGNvGnHgmiLquF0CWTsxXcJ9WQhaxcPusezKywb8ALlCQVXXYdsb9vE1xpzl
         469WoA5kiGa1qxVAlNT/Zc0iec3FwV2idwLweQ1rJIbTRDofPFZdX4l+ekBWoiYXX6Gb
         Ue+kSvJMFWy9iWTABrowUOGVQQ6JJpAgM9mXbobSBW0GoZj1cHrl6Z9jHYHAAAClafa5
         rOShjp4CPq8gjdU+a9csG6TwcodYJIUWxdeeguMIe1oc/hteIqrn5kxl6DUhM2kkaI/3
         2Em6QRf0idCJOPBd8HLeoeUocgHF7Q0X8cNIQLUu4W/1SSD0gBEJnLLM2frX8SU1KVBS
         tIrg==
X-Gm-Message-State: APjAAAX/VRcUBXFdJaIVER8m15k9JQYRnF6nv3rHzY6or3MMKlERHhDy
        ovkau3G6hO99FyDMGjLKcU0=
X-Google-Smtp-Source: APXvYqy304rXbVDnxHEwwjd5Cdhw7PS0colGaO5tqp7nM5MG7oxwiK0IgzAtTMcf04uXEMXJRDke3Q==
X-Received: by 2002:a65:5c88:: with SMTP id a8mr10317050pgt.388.1560995122055;
        Wed, 19 Jun 2019 18:45:22 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id y22sm39926754pgj.38.2019.06.19.18.45.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 18:45:21 -0700 (PDT)
Message-ID: <1560995116.4771.1.camel@gmail.com>
Subject: Re: [PATCH 0/2] Fix handling of h_set_dawr
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mikey@neuling.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
Date:   Thu, 20 Jun 2019 11:45:16 +1000
In-Reply-To: <87e219c8-1db7-9976-03ce-5a566a8df7ab@kaod.org>
References: <20190617071619.19360-1-sjitindarsingh@gmail.com>
         <87e219c8-1db7-9976-03ce-5a566a8df7ab@kaod.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 2019-06-17 at 11:06 +0200, Cédric Le Goater wrote:
> On 17/06/2019 09:16, Suraj Jitindar Singh wrote:
> > Series contains 2 patches to fix the host in kernel handling of the
> > hcall
> > h_set_dawr.
> > 
> > First patch from Michael Neuling is just a resend added here for
> > clarity.
> > 
> > Michael Neuling (1):
> >   KVM: PPC: Book3S HV: Fix r3 corruption in h_set_dabr()
> > 
> > Suraj Jitindar Singh (1):
> >   KVM: PPC: Book3S HV: Only write DAWR[X] when handling h_set_dawr
> > in
> >     real mode
> 
> 
> 
> Reviewed-by: Cédric Le Goater <clg@kaod.org>
> 
> and 
> 
> Tested-by: Cédric Le Goater <clg@kaod.org>
> 
> 
> but I see slowdowns in nested as if the IPIs were not delivered. Have
> we
> touch this part in 5.2 ? 

Hi,

I've seen the same and tracked it down to decrementer exceptions not
being delivered when the guest is using large decrementer. I've got a
patch I'm about to send so I'll CC you.

Another option is to disable the large decrementer with:
-machine pseries,cap-large-decr=false

Thanks,
Suraj

> 
> Thanks,
> 
> C.
> 
