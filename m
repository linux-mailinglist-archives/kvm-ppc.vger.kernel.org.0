Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1BD17B428
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Mar 2020 03:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCFCJl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Mar 2020 21:09:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbgCFCJl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Mar 2020 21:09:41 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 026293sT005306
        for <kvm-ppc@vger.kernel.org>; Thu, 5 Mar 2020 21:09:40 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yj4q3568t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 05 Mar 2020 21:09:40 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <gromero@linux.vnet.ibm.com>;
        Fri, 6 Mar 2020 02:09:38 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 02:09:36 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02629ZOZ59965546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 02:09:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E69A404D;
        Fri,  6 Mar 2020 02:09:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7C7FA4040;
        Fri,  6 Mar 2020 02:09:34 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 02:09:34 +0000 (GMT)
Received: from bran.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        by ozlabs.au.ibm.com (Postfix) with ESMTP id D4825A011F;
        Fri,  6 Mar 2020 13:09:29 +1100 (AEDT)
Received: from oc6336877782.ibm.com (gustavo.ozlabs.ibm.com [10.61.2.143])
        by bran.ozlabs.ibm.com (Postfix) with ESMTP id 8E9ECE00FA;
        Fri,  6 Mar 2020 13:09:33 +1100 (AEDT)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix typos in comments
To:     Gabriel Paubert <paubert@iram.es>,
        Gustavo Romero <gromero@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <1583454396-1424-1-git-send-email-gromero@linux.ibm.com>
 <20200306020607.GA29843@lt-gp.iram.es>
From:   Gustavo Romero <gromero@linux.vnet.ibm.com>
Date:   Fri, 6 Mar 2020 13:09:33 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200306020607.GA29843@lt-gp.iram.es>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20030602-0012-0000-0000-0000038D9DD6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030602-0013-0000-0000-000021CA5ED9
Message-Id: <3cc3c74a-892e-56eb-f99d-f21ec993445e@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_08:2020-03-05,2020-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060011
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Gabriel,

On 03/06/2020 01:06 PM, Gabriel Paubert wrote:
> On Fri, Mar 06, 2020 at 11:26:36AM +1100, Gustavo Romero wrote:
>> Fix typos found in comments about the parameter passed
>> through r5 to kvmppc_{save,restore}_tm_hv functions.
> 
> Actually "iff" is a common shorthand in some fields and not necessarily
> a spelling error:
> 
> https://en.wikipedia.org/wiki/If_and_only_if

I see. Thank you.


Best regards,
Gustavo

