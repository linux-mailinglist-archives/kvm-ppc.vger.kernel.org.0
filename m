Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7495472AD
	for <lists+kvm-ppc@lfdr.de>; Sun, 16 Jun 2019 03:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFPBKo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 21:10:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbfFPBKn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 15 Jun 2019 21:10:43 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5G16w9a139909
        for <kvm-ppc@vger.kernel.org>; Sat, 15 Jun 2019 21:10:42 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t5amh9wxc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 15 Jun 2019 21:10:42 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Sun, 16 Jun 2019 02:10:40 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 16 Jun 2019 02:10:37 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5G1AYdM49283240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jun 2019 01:10:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80D725204F;
        Sun, 16 Jun 2019 01:10:34 +0000 (GMT)
Received: from ram.ibm.com (unknown [9.80.224.136])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8FC2552051;
        Sun, 16 Jun 2019 01:10:31 +0000 (GMT)
Date:   Sat, 15 Jun 2019 18:10:28 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        rgrimm@us.ibm.com
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-8-cclaudio@linux.ibm.com>
 <20190615074334.GD24709@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615074334.GD24709@blackberry>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19061601-0016-0000-0000-000002896BCC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061601-0017-0000-0000-000032E6B08F
Message-Id: <20190616011028.GA10806@ram.ibm.com>
Subject: Re:  Re: [PATCH v3 7/9] KVM: PPC: Ultravisor: Restrict LDBAR access
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-16_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906160009
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Jun 15, 2019 at 05:43:34PM +1000, Paul Mackerras wrote:
> On Thu, Jun 06, 2019 at 02:36:12PM -0300, Claudio Carvalho wrote:
> > When the ultravisor firmware is available, it takes control over the
> > LDBAR register. In this case, thread-imc updates and save/restore
> > operations on the LDBAR register are handled by ultravisor.
> > 
> > Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> 
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> 
> Just a note on the signed-off-by: it's a bit weird to have Ram's
> signoff when he is neither the author nor the sender of the patch.
> The author is assumed to be Claudio; if that is not correct then the
> patch should have a From: line at the start telling us who the author
> is, and ideally that person should have a signoff line before
> Claudio's signoff as the sender of the patch.

Ryan originally wrote this patch, which I than modified,
before Claudio further modified it to its current form.

So I think the author should be Ryan.

RP

