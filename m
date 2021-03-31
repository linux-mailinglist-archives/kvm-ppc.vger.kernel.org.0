Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6587934F7FB
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCaE2L (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhCaE2L (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 00:28:11 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F71C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Mar 2021 21:28:10 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9Cwm4tspz9sVq; Wed, 31 Mar 2021 15:28:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617164888; bh=bzfJZ1XyYCAEGWSrsQejGXPgeiIBH5brzLLsqIGTufs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AvLMSU/r2oBAxwxUYw0kAKKUDxWWCfzjC3RhWsdiWQ0m032RsPafOGVLCMxenX8dp
         DL85cSL9qKxl7nI4LupUV0bUnzKXkcqNO3mzCkLoM5GpumE0l7EalBO7Tn6+aV8lYO
         N/+amoE7gloncPDDKFEXTjd8hOx5REFN90hkXn9vAgpdj0VUWerWFtg8fCB0GynExB
         MvIzlC15zls7ntnlhu4G++9kGue8iovZHCMuQIUlKpxMp1aDU+uPdqAqvOnOOQIETg
         EHh8I9NpgLsE9U7jlbzSLy5CZs8wHN1buQgG51rJuiPZuvxqH3HkFGWUO4ON11d4zm
         o+uq3Xi/xPijg==
Date:   Wed, 31 Mar 2021 15:28:01 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v4 03/46] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be
 set to 1 or 2
Message-ID: <YGP6Ucf8d7c4wZbo@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-4-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-4-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:22AM +1000, Nicholas Piggin wrote:
> These are already disallowed by H_SET_MODE from the guest, also disallow
> these by updating LPCR directly.
> 
> AIL modes can affect the host interrupt behaviour while the guest LPCR
> value is set, so filter it here too.
> 
> Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
