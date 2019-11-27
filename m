Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC1710ABA9
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Nov 2019 09:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfK0IYo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Nov 2019 03:24:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27759 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726125AbfK0IYo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Nov 2019 03:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574843083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9tkF17QBGkfFHQURdPltFegkTj6mQbNPfTet7rLLyU=;
        b=iHhfivG55e/0r6wDEZwnK3hAMuSkxYCLrbOuyLp6+7nJDVF1G95KKKgwzuTfvaNs7mxjoh
        yAd5KvlK99Tu9RJ3hN69o7qG8FYXw34yZMsBqJRAk+Ke7ADX3fWwpo1Cc6Mee7nQ2Bz3qx
        IF6+i1pM383Tfw7wZ4CNMNBoM6equMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-5gUolSY-MtyIGhWjQsGqeg-1; Wed, 27 Nov 2019 03:24:40 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A32D180183C;
        Wed, 27 Nov 2019 08:24:39 +0000 (UTC)
Received: from kaapi (unknown [10.33.36.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF435D9D6;
        Wed, 27 Nov 2019 08:24:37 +0000 (UTC)
Date:   Wed, 27 Nov 2019 13:54:33 +0530 (IST)
From:   P J P <ppandit@redhat.com>
X-X-Sender: pjp@kaapi
To:     Paul Mackerras <paulus@ozlabs.org>
cc:     kvm-ppc@vger.kernel.org, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH v2] kvm: mpic: limit active IRQ sources to NUM_OUTPUTS
In-Reply-To: <nycvar.YSQ.7.76.1911211023470.11913@xnncv>
Message-ID: <nycvar.YSQ.7.76.1911271353480.20787@xnncv>
References: <20191115050620.21360-1-ppandit@redhat.com> <20191120023334.GA24617@oak.ozlabs.ibm.com> <nycvar.YSQ.7.76.1911201625080.24911@xnncv> <20191120214119.GA12722@blackberry> <nycvar.YSQ.7.76.1911211023470.11913@xnncv>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 5gUolSY-MtyIGhWjQsGqeg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

+-- On Thu, 21 Nov 2019, P J P wrote --+
| Considering E500 is mostly used for SoC/Embedded systems. It is not clear=
 if=20
| this issue can be misused from a guest running on PPC E500 platform.
|=20
| ...wdyt?

Paul, any idea?
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

